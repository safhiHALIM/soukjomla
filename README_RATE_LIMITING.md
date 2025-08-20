# Rate Limiting Configuration

## État Actuel
Le rate limiting est **DÉSACTIVÉ** pour faciliter le développement et les tests.

## Problème Résolu
- ❌ Erreur: "Too many requests from this IP, please try again later."
- ✅ Solution: Rate limiting désactivé dans `server.js`

## Configuration Actuelle

### Lignes Commentées dans server.js:
```javascript
// app.use(limiter); // Rate limiting désactivé pour le développement

// Apply strict rate limiting to sensitive endpoints (désactivé pour le développement)
// app.use('/api/generate-link', strictLimiter);
// app.use('/api/check-link', strictLimiter);
// app.use('/api/admin/login', strictLimiter);
```

## Pour Réactiver en Production

### 1. Décommentez les lignes dans server.js:
```javascript
app.use(limiter); // Rate limiting activé

// Apply strict rate limiting to sensitive endpoints
app.use('/api/generate-link', strictLimiter);
app.use('/api/check-link', strictLimiter);
app.use('/api/admin/login', strictLimiter);
```

### 2. Ajustez les limites dans .env:
```env
RATE_LIMIT_WINDOW_MS=900000    # 15 minutes
RATE_LIMIT_MAX_REQUESTS=100    # 100 requêtes par IP
```

## Configuration Recommandée pour Production

### Rate Limiting Standard:
- **Fenêtre**: 15 minutes
- **Limite**: 100 requêtes par IP
- **Message**: "Too many requests from this IP, please try again later."

### Rate Limiting Strict (endpoints sensibles):
- **Fenêtre**: 15 minutes  
- **Limite**: 10 requêtes par IP
- **Endpoints**: `/api/generate-link`, `/api/check-link`, `/api/admin/login`

## Avantages du Rate Limiting

### Sécurité:
- Protection contre les attaques DDoS
- Prévention du brute force sur les logins
- Limitation des abus d'API

### Performance:
- Évite la surcharge du serveur
- Maintient la qualité de service
- Protège la base de données

## Notes de Développement

- **Développement**: Rate limiting désactivé pour faciliter les tests
- **Production**: Réactiver impérativement le rate limiting
- **Test**: Utiliser des outils comme Postman avec modération

## Commandes Utiles

### Redémarrer le serveur:
```bash
npm start
```

### Vérifier les processus:
```bash
netstat -ano | findstr :3000
```

### Tuer un processus:
```bash
taskkill /PID [PID_NUMBER] /F
```