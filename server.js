const express = require('express');
const session = require('express-session');
const rateLimit = require('express-rate-limit');
const cors = require('cors');
const path = require('path');
const fs = require('fs');
require('dotenv').config();

const db = require('./config/db');
const storeRoutes = require('./routes/store');

const app = express();
const PORT = process.env.PORT || 3000;

// Create uploads directory if it doesn't exist
const uploadsDir = path.join(__dirname, 'public', 'uploads');
if (!fs.existsSync(uploadsDir)) {
    fs.mkdirSync(uploadsDir, { recursive: true });
}

// Rate limiting middleware
const limiter = rateLimit({
    windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 15 * 60 * 1000, // 15 minutes
    max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS) || 100, // limit each IP to 100 requests per windowMs
    message: 'Too many requests from this IP, please try again later.',
    standardHeaders: true,
    legacyHeaders: false,
});

// Stricter rate limiting for sensitive endpoints
const strictLimiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 10, // limit each IP to 10 requests per windowMs
    message: 'Too many attempts, please try again later.',
});

// Middleware
app.use(cors());
// app.use(limiter); // Rate limiting désactivé pour le développement
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Session configuration
app.use(session({
    secret: process.env.SESSION_SECRET || 'fallback-secret-change-in-production',
    resave: false,
    saveUninitialized: false,
    cookie: {
        secure: process.env.NODE_ENV === 'production',
        httpOnly: true,
        maxAge: 24 * 60 * 60 * 1000 // 24 hours
    }
}));

// Serve static files
app.use(express.static(path.join(__dirname, 'public')));

// API Routes
app.use('/api', storeRoutes);

// Route temporaire pour migration des catégories
app.post('/api/migrate-categories', async (req, res) => {
    try {
        // Ajouter la colonne icon si elle n'existe pas
        await db.query(`
            ALTER TABLE categories 
            ADD COLUMN IF NOT EXISTS icon VARCHAR(50) DEFAULT 'bi-tag' AFTER description
        `);
        
        // Mettre à jour les catégories existantes
        const updates = [
            { name: 'Electronics', icon: 'bi-phone' },
            { name: 'Clothing', icon: 'bi-person-fill' },
            { name: 'Books', icon: 'bi-book' },
            { name: 'Home & Garden', icon: 'bi-house' },
            { name: 'Sports', icon: 'bi-trophy' }
        ];
        
        for (const update of updates) {
            await db.query(
                'UPDATE categories SET icon = ? WHERE name = ?',
                [update.icon, update.name]
            );
        }
        
        // Ajouter nouvelles catégories électroniques
        const newCategories = [
            { name: 'Smartphones', description: 'Téléphones intelligents et accessoires', icon: 'bi-phone' },
            { name: 'Ordinateurs', description: 'Ordinateurs portables et de bureau', icon: 'bi-laptop' },
            { name: 'Audio', description: 'Écouteurs, haut-parleurs et équipements audio', icon: 'bi-headphones' },
            { name: 'Photo & Vidéo', description: 'Appareils photo, caméras et accessoires', icon: 'bi-camera' },
            { name: 'Gaming', description: 'Consoles de jeux et accessoires gaming', icon: 'bi-controller' },
            { name: 'Montres Connectées', description: 'Smartwatches et montres fitness', icon: 'bi-smartwatch' },
            { name: 'Tablettes', description: 'Tablettes et accessoires', icon: 'bi-tablet' },
            { name: 'Accessoires Tech', description: 'Câbles, chargeurs et accessoires divers', icon: 'bi-usb-plug' }
        ];
        
        for (const category of newCategories) {
            await db.query(`
                INSERT INTO categories (name, description, icon) 
                VALUES (?, ?, ?) 
                ON DUPLICATE KEY UPDATE 
                    description = VALUES(description),
                    icon = VALUES(icon)
            `, [category.name, category.description, category.icon]);
        }
        
        // Récupérer toutes les catégories
        const [categories] = await db.query('SELECT * FROM categories ORDER BY name');
        
        res.json({
            success: true,
            message: 'Migration des catégories terminée avec succès!',
            categories: categories
        });
        
    } catch (error) {
        console.error('Erreur migration catégories:', error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la migration',
            error: error.message
        });
    }
});

// Apply strict rate limiting to sensitive endpoints (désactivé pour le développement)
// app.use('/api/generate-link', strictLimiter);
// app.use('/api/check-link', strictLimiter);
// app.use('/api/admin/login', strictLimiter);

// Serve admin page (protected route will be handled by frontend)
app.get('/admin', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'admin.html'));
});

// Serve setup guide
app.get('/setup', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'setup.html'));
});

// Serve access link page
app.get('/access/:token', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'access.html'));
});

// Catch-all route for SPA
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Error handling middleware
app.use((err, req, res, next) => {
    console.error('Error:', err);
    res.status(500).json({ 
        success: false, 
        message: 'Internal server error',
        error: process.env.NODE_ENV === 'development' ? err.message : undefined
    });
});

// Graceful shutdown
process.on('SIGTERM', () => {
    console.log('SIGTERM received, shutting down gracefully');
    db.end(() => {
        console.log('Database connection closed');
        process.exit(0);
    });
});

// Start server
app.listen(PORT, () => {
    console.log(`Soukjomla Store server running on port ${PORT}`);
    console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
    console.log(`Admin panel: http://localhost:${PORT}/admin`);
});

module.exports = app;