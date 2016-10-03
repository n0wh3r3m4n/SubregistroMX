
### Para simplificar la carga de datos, hacer que el directorio de trabajo
### sea el que tiene los zip files de las distintas entidades federativas y los
### shapefiles del pais

setwd("C:/Users/amuente/Documents/Proyectos 2016/Registries/Intercensal Mexico 2015/TODOS_PERSONAS")

### Cargar la informacion de las 32 entidades federativas

TODOS <- data.frame(matrix(ncol=9,nrow=0))

for (i in 1:32)
{
  data_state <- read.csv(sprintf("TR_PERSONA%02d.CSV",i))
  ent <- i
  estado <- as.character(data_state$NOM_ENT[1])
  for (j in unique(data_state$MUN))
  {
    tmp <- data_state[data_state$MUN == j,]
    municipio <- as.character(tmp$NOM_MUN[1])
    data_expanded <- tmp[rep(row.names(tmp),tmp$FACTOR),]
    tmp_2 <- as.data.frame.matrix(as.matrix(xtabs( ~ data_expanded$EDAD + data_expanded$ACTA_NAC)))
    if (is.null(tmp_2$'1') == TRUE) {tmp_2$'1' <- NA}
    if (is.null(tmp_2$'2') == TRUE) {tmp_2$'2' <- NA}
    if (is.null(tmp_2$'3') == TRUE) {tmp_2$'3' <- NA}
    if (is.null(tmp_2$'9') == TRUE) {tmp_2$'9' <- NA}
    edad <- rownames(tmp_2)
    rownames(tmp_2) <- NULL
    tmp_2 <- cbind(ent,estado,j,municipio,edad,tmp_2)
    TODOS <- rbind(TODOS,tmp_2, stringsAsFactors = FALSE)
  }
}

### Cambiar nombre de campos, reemplazar datos de factor a numerico

for (i in c(5:9))
{
  TODOS[,i] <- as.numeric(as.character(TODOS[,i]))
}

names(TODOS) <- c("ENT","ESTADO","MUN","MUNICIPIO","EDAD","TIENE","NOTIENE","OTROPAIS","NOSABE")

### Creacion de variable unica para cada municipio

TODOS$var <- paste(sprintf("%02d",TODOS$ENT),sprintf("%03d",TODOS$MUN),sep = "-")

### dataframe con agregados totales por municipio

sumxmun <- aggregate(TODOS[c(6:9)],by = list(var = TODOS$var,ESTADO = TODOS$ESTADO), FUN = sum)

### Repetir para niños de 0 a 5 años

TODOS5 <- TODOS[TODOS$EDAD <5,]
sumxmun5 <- aggregate(TODOS5[c(6:9)],by = list(var = TODOS5$var,ESTADO = TODOS5$ESTADO), FUN = sum)

### Dataframe con sumas totales y para menores de 5 años por municipio

sumxmunfinal <- merge(sumxmun,sumxmun5[c(1,3:6)],by = "var",sort = FALSE)
names(sumxmunfinal) <- c("var","ESTADO","TIENE","NOTIENE","OTROPAIS","NOSABE","TIENE5","NOTIENE5","OTROPAIS5","NOSABE5")

### Calculo de tasa de subregistro total y para menores de 5 años

sumxmunfinal$sub <- round(sumxmunfinal$NOTIENE/(sumxmunfinal$TIENE + sumxmunfinal$NOTIENE)*100,2)
sumxmunfinal$sub5 <- round(sumxmunfinal$NOTIENE5/(sumxmunfinal$TIENE5 + sumxmunfinal$NOTIENE5)*100,2)

### Leer base de datos del shapefile de areas geoestadisticas municipales

geo_orig <- read.dbf("areas_geoestadisticas_municipales.dbf")
geo_orig$var <- paste(geo_orig$CVE_ENT,geo_orig$CVE_MUN,sep = "-")

### En diciembre de 2015, Puerto Morelos se separa del municipio de Benito Juarez.
### Si bien los shapefiles del INEGI incluyen a hora a Puerto Morelos, la encuesta no. Para corregir esto, decidi agregar
### una fila para puerto morelos sin informacion.

### Agregar Puerto Morelos a sumxmunfinal

ptomorelos <- c("23-011","Quintana Roo","NA","NA","NA","NA","NA","NA","NA","NA","NA","NA")
sumxmunfinal <- rbind(sumxmunfinal,ptomorelos)

### Creacion de dataframe con informacion de registro para todos los municipios

final <- merge(geo_orig,sumxmunfinal,by = "var",all.x = TRUE,sort = FALSE)

### Eliminar tildes (carto no muestra bien las tildes)

til <- c("á","é","í","ó","ú","ü")
sin <- c("a","e","i","o","u","u")

for (i in 1:length(til))
  {
  final <- as.data.frame(lapply(final,function(x){gsub(til[i],sin[i],x)}))
  }

### Escribir base de datos para agregar al shapefile datos de subregistro por municipio.

write.dbf(final,"areas_geoestadisticas_municipales.dbf")

rm(data_state,ent,estado,tmp,tmp_2,TODOS,TODOS5,sumxmun,sumxmun5,sumxmunfinal,ptomorelos,
   municipio,data_expanded,edad,i,j,til,sin)
