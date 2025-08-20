# 🔍 Guide de Debug - Barre de Recherche

## 🧪 **Tests à Effectuer :**

### **1. Test de Base :**
1. **Ouvrir** http://localhost:3000
2. **Ouvrir la console** (F12 → Console)
3. **Taper dans la barre de recherche** : "phone"
4. **Appuyer sur Enter** ou cliquer sur la loupe
5. **Vérifier les logs** dans la console

### **2. Tests Manuels Console :**
```javascript
// Test 1: Vérifier que la fonction existe
console.log(typeof performSearch);
// Résultat attendu: "function"

// Test 2: Tester la fonction directement
performSearch();
// Doit afficher les logs 🔍

// Test 3: Vérifier l'élément de recherche
console.log(document.getElementById('searchInput'));
// Doit retourner l'élément input

// Test 4: Test avec une valeur
document.getElementById('searchInput').value = 'test';
performSearch();
```

### **3. Page de Debug :**
- **Aller sur** http://localhost:3000/debug_search.html
- **Cliquer sur "Test Fonctions"** pour vérifier les fonctions
- **Cliquer sur "Test API Direct"** pour tester l'API
- **Regarder les logs** en temps réel

### **4. Vérifications Étape par Étape :**

#### **A. Fonction performSearch :**
```javascript
// Dans la console, taper :
window.performSearch
// Doit retourner la fonction
```

#### **B. Élément de recherche :**
```javascript
// Dans la console, taper :
document.getElementById('searchInput')
// Doit retourner l'input de recherche
```

#### **C. Événements :**
```javascript
// Vérifier les événements attachés
getEventListeners(document.getElementById('searchInput'))
// Doit montrer les événements keydown, input, etc.
```

## 🐛 **Problèmes Possibles :**

### **1. Fonction non définie :**
- **Symptôme** : `performSearch is not defined`
- **Cause** : Script non chargé ou erreur JavaScript
- **Solution** : Vérifier la console pour les erreurs

### **2. Élément non trouvé :**
- **Symptôme** : `Cannot read property 'value' of null`
- **Cause** : ID de l'input incorrect
- **Solution** : Vérifier que l'ID est bien "searchInput"

### **3. API non accessible :**
- **Symptôme** : Erreur 404 ou 500
- **Cause** : Serveur non démarré ou route incorrecte
- **Solution** : Redémarrer le serveur

### **4. Pas de redirection :**
- **Symptôme** : Reste sur la page d'accueil
- **Cause** : Fonction showPage non définie
- **Solution** : Vérifier que toutes les fonctions sont chargées

## 🔧 **Solutions Rapides :**

### **1. Redémarrer le Serveur :**
```bash
cd d:\project
# Arrêter le serveur (Ctrl+C)
npm start
```

### **2. Vider le Cache :**
- **Ctrl+F5** pour recharger sans cache
- Ou **F12 → Network → Disable cache**

### **3. Test Direct API :**
```javascript
// Dans la console :
fetch('/api/products?search=phone')
  .then(r => r.json())
  .then(d => console.log(d));
```

### **4. Forcer le Rechargement :**
```javascript
// Dans la console :
location.reload(true);
```

## 📊 **Logs Attendus :**

### **Logs Normaux :**
```
🔍 performSearch called
🔍 Search query: phone
🔍 Search input element: <input...>
🔍 Hiding suggestions
🔍 Updated filters: {search: "phone", page: 1, limit: 12}
🔍 Showing catalog page
🔍 Loading products
🔍 Products grid element: <div...>
🔍 performSearch completed
Loading products from: /api/products?search=phone&page=1&limit=12
Products response: {success: true, products: [...]}
```

### **Logs d'Erreur :**
```
🔍 showPage function not found
🔍 loadProducts function not found
Error loading products: TypeError...
```

## ✅ **Test Final :**

Si tout fonctionne, vous devriez voir :
1. **Console** : Logs 🔍 sans erreurs
2. **Page** : Redirection vers le catalogue
3. **Résultats** : Produits filtrés affichés
4. **URL** : Change pour inclure les filtres

## 🚨 **Si Ça Ne Marche Toujours Pas :**

1. **Copier tous les logs** de la console
2. **Faire une capture d'écran** de l'erreur
3. **Vérifier** que le serveur fonctionne sur http://localhost:3000
4. **Tester** la page de debug : http://localhost:3000/debug_search.html

La recherche devrait maintenant fonctionner ! 🎯