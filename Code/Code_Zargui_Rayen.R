# Chargement des packages
library(readr)
library(ggplot2)
library(gridExtra)
library(FactoMineR)
library(corrplot)
library(MASS)
library(pls)
# Couleurs pour les graphiques
colors <- c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd",
            "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf", "#aec7e8")

# Chargement des données
mtcars <- read_csv("mtcars.csv")
data("mtcars")
#  Aperçu des données
View(mtcars)
head(mtcars)
summary(mtcars)
str(mtcars)
dim(mtcars)

# Paires de variables
pairs(mtcars)

# Matrice de corrélation
cor_matrix <- cor(mtcars)
corrplot(cor_matrix, method = "circle")

# Histogrammes des variables
plot_list <- list()
for (i in 1:ncol(mtcars)) {
  plot_list[[i]] <- ggplot(mtcars, aes(x = .data[[names(mtcars)[i]]])) +
    geom_histogram(fill = colors[i %% length(colors) + 1], color = "white", bins = 10, alpha = 0.8) +
    labs(title = paste("Distribution de", names(mtcars)[i]),
         x = names(mtcars)[i],
         y = "Fréquence") +
    theme_minimal() +
    theme(plot.title = element_text(size = 10))
}
grid.arrange(grobs = plot_list, ncol = 3)

# Boxplot global
boxplot(mtcars, main = "Boxplots des variables de mtcars", col = "lightblue", las = 2)


# Définir variables actives et illustratives
vars_actives <- c("mpg", "disp", "hp", "drat", "wt", "qsec")
vars_illustratives <- c("cyl", "vs", "am", "gear", "carb")
data_active <- mtcars[, vars_actives]
data_illustrative <- mtcars[, vars_illustratives]

# Test de Shapiro-Wilk pour la normalité (sur les variables actives)
shapiro_results <- lapply(data_active, shapiro.test)

# Affichage des résultats de normalité de test de shapiro
for (i in 1:length(shapiro_results)) {
  cat("Variable :", names(shapiro_results)[i], "\n")
  cat("p-value  :", round(shapiro_results[[i]]$p.value, 4), "\n")
  cat("Conclusion :", ifelse(shapiro_results[[i]]$p.value < 0.05, 
                             "Non normale", "Normale"), "\n\n")
}
#regression

#modele initiale
full_model <- lm(mpg ~ cyl + disp + hp + drat + wt + qsec + vs + am + gear + carb, data = mtcars)
summary(full_model)

#modele selection
modele_selection <- stepAIC(full_model, direction = "both", trace = FALSE)
summary(modele_selection)

#comparaison
par(mfrow = c(1, 2))
plot(full_model, which = 1, main = "Résidus du modèle complet")
plot(modele_selection, which = 1, main = "Résidus du modèle sélectionné")

#ajout de voiture
nouveau_vehicule <- data.frame(
  mpg = 35,     # consommation très économe
  cyl = 4,
  disp = 95,
  hp = 80,
  drat = 4.1,
  wt = 2.0,
  qsec = 18.5,
  vs = 1,
  am = 1,
  gear = 5,
  carb = 1
)
mtcars_ajout <- rbind(mtcars, nouveau_vehicule)
modele_complet_ajout <- lm(mpg ~ ., data = mtcars_ajout)
modele_reduit_ajout <- lm(mpg ~ wt + qsec + am, data = mtcars_ajout)
summary(modele_complet_ajout)
summary(modele_reduit_ajout)

#ACP

# Centrage-réduction des données
acp_data <- scale(mtcars[, -1])  # Conserve toutes les variables sauf mpg

### 2. Analyse en Composantes Principales ###
res_acp <- prcomp(acp_data, center = TRUE, scale. = TRUE)
summary(res_pca)

### 3. Visualisation des résultats ###

# Valeurs propres et variance expliquée

res_pca$eig
fviz_eig(res_pca, addlabels = TRUE, barfill = "#2E9FDF", barcolor = "#2E9FDF", linecolor = "#FC4E07", ylim = c(0, 80), main = "Scree Plot - Variance expliquée",xlab = "Composantes Principales",ylab = "Pourcentage de Variance Expliquée")

# Cercle des corrélations
fviz_pca_var(res_acp,
             col.var = "contrib",
             gradient.cols = c("#4E79A7", "#59A14F", "#E15759"),
             repel = TRUE,
             title = "Cercle des Corrélations")

# Contributions aux axes
fviz_contrib(res_acp, 
             choice = "var", 
             axes = 1,
             fill = "#4E79A7",
             color = "#4E79A7",
             title = "Contribution des Variables à PC1")
fviz_contrib(res_acp, 
             choice = "var", 
             axes = 2,
             fill = "#59A14F",
             color = "#59A14F",
             title = "Contribution des Variables à PC2")

### 4. Projection des individus ###
fviz_pca_ind(res_acp,
             col.ind = as.factor(mtcars$cyl),
             palette = c("#4E79A7", "#59A14F", "#E15759"),  # Couleurs pour 4/6/8 cyl
             addEllipses = TRUE,
             ellipse.type = "confidence",
             legend.title = "Cylindres",
             title = "Projection des Véhicules sur PC1-PC2",
             axes = c(1, 2))  # PC1 et PC2 uniquement

# Extraction des 2 premières composantes
scores <- as.data.frame(res_acp$x[, 1:2])
colnames(scores) <- c("PC1", "PC2")
scores$mpg <- mtcars$mpg  # Ajout de la variable cible

model_pcr <- lm(mpg ~ PC1 + PC2, data = scores)
summary(model_pcr)

library(ggplot2)
ggplot(scores, aes(x = PC1, y = mpg)) +
  geom_point(aes(color = as.factor(mtcars$cyl)), size = 3) +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  labs(title = "Régression: mpg ~ PC1",
       x = "Composante 1 (60.1% variance)",
       y = "mpg",
       color = "Cylindres") +
  scale_color_manual(values = c("#4E79A7", "#59A14F", "#E15759"))

par(mfrow = c(2, 2))
plot(model_pcr)
# test de model
anova(model_pcr, full_model)