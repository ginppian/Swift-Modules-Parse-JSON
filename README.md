Swift Modules: Parse JSON
===========

## Descripción:

<p align="justify">
	En el <a href="https://github.com/ginppian/Swift-Modules-Consum-REST-Service-With-POST">tutoría anterior</a> hicimos el consumo de servicios REST. Para continuar con este tutoría ahora a esos datos que obtuvimos, les daremos un formato.
</p>

<p align="justify">
	Siempre es importante tener en cuenta la <b>experiencia</b> de usuario por esta razón pondremos un <i>UIActivityIndicator</i> mientras se descargan los datos, para posteriormente desplegarlos. La manera más conveniente de almacenarlos es en <b>objetos</b> pues al fin de cuentas eso son. Recodemos que JSON nos trae un <i>array</i> de <i>objetos</i> y hay que tratarlos como tal.
</p>

## Especificaciones Técnicas:

* Xcode 8.3.2
* [Pod SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
* [Pod AlamofireObjectMapper](https://github.com/tristanhimmelman/AlamofireObjectMapper)

## Marco Teórico

* Parser: 

<p align="justify">
	<a href="https://es.wikipedia.org/wiki/Analizador_sint%C3%A1ctico">Un analizador sintáctico (o parser)</a> es una de las partes de un compilador que transforma su entrada en un árbol de derivación.
</p>

<p align="justify">
El análisis sintáctico convierte el texto de entrada en otras estructuras (comúnmente árboles), que son más útiles para el posterior análisis y capturan la jerarquía implícita de la entrada. Un analizador léxico crea tokens de una secuencia de caracteres de entrada y son estos tokens los que son procesados por el analizador sintáctico para construir la estructura de datos, por ejemplo un árbol de análisis o árboles de sintaxis abstracta.
</p>

<p align="justify">
<b>Es decir,</b> para fines prácticos un <b>parser</b> en <i>JSON</i> es intercambiar datos que recibimos de un <i>Servidor Web</i> (pues siempre vienen como un <i>String</i>) a un formato de <i>"Clave":Valor</i> o un formato <i>JSON</i>.
</p>









