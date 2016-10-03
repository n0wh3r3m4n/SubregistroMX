# SubregistroMX
Analisis de datos de subregistro de la encuesta intercensal de 2015 de INEGI.

## Mapas municipales
1. Primero, hay que bajarse la informacion del INEGI.
    a. microdatos de la intercensal disponibles (octubre 2016) en: http://www3.inegi.org.mx/sistemas/microdatos/formato.aspx?c=34537 (si, hay que hacer 32 downloads :/)
    b. los shapefiles disponibles (octubre 2016) en: http://www3.inegi.org.mx/sistemas/biblioteca/ficha.aspx?upc=702825217341
2. De todo el catálogo de shapefiles yo he usado solo los files correspondientes a areas_geoestadisticas_estatales y areas_geoestadisticas_municipales.
3. fileforcarto.R es un script en R para crear un archivo .dbf que reemplace al archivo .dbf del shapefile de areas_geoestadisticas_municipales.
4. Una vez en carto, use el siguiente query para calcular la densidad por municipio:

SELECT *
	, (notiene5/(ST_Area(the_geom::GEOGRAPHY)/1000000)) as densidad
FROM areas_geoestadisticas_municipales_1

5. Para la leyenda use el siguiente codigo:

<div class='cartodb-legend choropleth'>
<div class="legend-title" style="color:#284a59">Densidad de niños sin partida por km2</div>
<ul>
	<li class="graph leg" style="border-radius: 0; border:none">
<div class="colors">
<div class="quartile" style="background-color:#FFFFB2"></div>
<div class="quartile" style="background-color:#FECC5C"></div>
<div class="quartile" style="background-color:#FD8D3C"></div>
<div class="quartile" style="background-color:#F03B20"></div>
<div class="quartile" style="background-color:#BD0026"></div>
</div>
	</li>
<p style="padding-top:5px">
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0.1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0.5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;10&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;50
</ul>
</div>

6. Los mapas estan disponibles en:
https://n0wh3r3m4n.carto.com/viz/a77536ba-e238-4913-9d60-402139a1ebb2/public_map (densidad de niños)
https://n0wh3r3m4n.carto.com/viz/7e3a29c0-80e0-11e6-be2c-0ee66e2c9693/public_map (numero de niños)
