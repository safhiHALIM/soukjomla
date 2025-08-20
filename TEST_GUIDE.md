# 🧪 Guide de Test - Images Multiples

## ✅ **Étapes de Test :**

### **1. Démarrage du Serveur :**
```bash
cd d:\project
npm start
```
Le serveur devrait démarrer sur http://localhost:3000

### **2. Connexion Admin :**
1. Aller sur http://localhost:3000/admin
2. Se connecter avec les identifiants admin
3. Vérifier que le dashboard s'affiche

### **3. Test Création Produit :**

#### **A. Produit sans images :**
1. Cliquer sur "Add Product"
2. Remplir les champs obligatoires :
   - Name: "Test Product 1"
   - Description: "Test description"
   - Price: 99.99
   - Stock: 10
   - Category: Sélectionner une catégorie
3. Cliquer "Save Product"
4. ✅ **Résultat attendu :** Message de succès + produit dans la liste

#### **B. Produit avec une image :**
1. Cliquer sur "Add Product"
2. Remplir les champs obligatoires
3. Sélectionner 1 image dans le champ "Product Images"
4. Vérifier que l'aperçu s'affiche
5. Cliquer "Save Product"
6. ✅ **Résultat attendu :** Produit créé avec image

#### **C. Produit avec images multiples :**
1. Cliquer sur "Add Product"
2. Remplir les champs obligatoires
3. Sélectionner 3-5 images dans le champ "Product Images"
4. Vérifier que tous les aperçus s'affichent
5. Changer l'image primaire dans le dropdown
6. Cliquer "Save Product"
7. ✅ **Résultat attendu :** Produit créé avec toutes les images

### **4. Test Affichage Client :**

#### **A. Page Catalogue :**
1. Aller sur http://localhost:3000
2. Cliquer sur "Catalogue"
3. ✅ **Vérifier :** Images primaires affichées sur les cartes produits

#### **B. Page Produit :**
1. Cliquer sur un produit avec images multiples
2. ✅ **Vérifier :**
   - Image principale affichée en grand
   - Miniatures en bas (si plusieurs images)
   - Clic sur miniature change l'image principale
   - Icône zoom visible au survol

#### **C. Modal Galerie :**
1. Sur la page produit, cliquer sur l'icône zoom
2. ✅ **Vérifier :**
   - Modal s'ouvre avec carrousel
   - Navigation avec flèches
   - Miniatures en bas de la modal
   - Clic sur miniature change l'image

### **5. Test Modification Produit :**

#### **A. Modifier produit existant :**
1. Dans l'admin, cliquer "Edit" sur un produit
2. ✅ **Vérifier :** Images existantes affichées
3. Ajouter de nouvelles images
4. Supprimer une image existante
5. Changer l'image primaire
6. Sauvegarder
7. ✅ **Vérifier :** Modifications appliquées

### **6. Test Suppression :**

#### **A. Supprimer image individuelle :**
1. Modifier un produit avec plusieurs images
2. Cliquer "Delete" sur une image
3. ✅ **Vérifier :** Image supprimée de la liste

#### **B. Supprimer produit complet :**
1. Cliquer "Delete" sur un produit
2. Confirmer la suppression
3. ✅ **Vérifier :** Produit et ses images supprimés

## 🐛 **Problèmes Possibles :**

### **Erreur "save product = error" :**
- **Cause :** Session admin expirée
- **Solution :** Se reconnecter à l'admin

### **Images ne s'affichent pas :**
- **Cause :** Problème de chemin ou permissions
- **Solution :** Vérifier le dossier `/public/uploads/`

### **Erreur 401 :**
- **Cause :** Non authentifié
- **Solution :** Se connecter en tant qu'admin

### **Erreur 500 :**
- **Cause :** Problème serveur/base de données
- **Solution :** Vérifier les logs du serveur

## 📊 **Résultats Attendus :**

✅ **Fonctionnalités qui doivent marcher :**
- Création produit avec/sans images
- Upload multiple d'images (jusqu'à 10)
- Sélection image primaire
- Aperçu images avant sauvegarde
- Modification images existantes
- Suppression images individuelles
- Affichage galerie côté client
- Navigation entre images
- Modal zoom avec carrousel
- Design responsive sur mobile

🎯 **Si tous les tests passent :** La fonctionnalité d'images multiples est opérationnelle !