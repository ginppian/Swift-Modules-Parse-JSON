Swift Modules: Parse JSON
===========

## Descripción:

<p align="justify">
	En el <a href="https://github.com/ginppian/Swift-Modules-Consum-REST-Service-With-POST">tutoría anterior</a> hicimos el consumo de servicios REST. Para continuar con este tutoría ahora a esos datos que obtuvimos, les daremos un formato.
</p>

<p align="justify">
	Siempre es importante tener en cuenta la <b>experiencia</b> de usuario por esta razón pondremos un <i>UIActivityIndicatorView</i> mientras se descargan los datos, para posteriormente desplegarlos. La manera más conveniente de almacenarlos es en <b>objetos</b> pues al fin de cuentas eso son. Recodemos que JSON nos trae un <i>array</i> de <i>objetos</i> y hay que tratarlos como tal.
</p>

## Especificaciones Técnicas:

* Xcode 8.3.2
* [Descargar el proyecto](https://github.com/ginppian/Swift-Modules-Consum-REST-Service-With-POST)
* Veremos en el tutorial: [Pod SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
* Veremos en el tutorial: [Pod AlamofireObjectMapper](https://github.com/tristanhimmelman/AlamofireObjectMapper)

## Marco Teórico

* Parser: 

<p align="justify">
	Un <a href="https://es.wikipedia.org/wiki/Analizador_sint%C3%A1ctico">analizador sintáctico o parser</a> es una de las partes de un compilador que transforma su entrada en un árbol de derivación.
</p>

<p align="justify">
El análisis sintáctico convierte el texto de entrada en otras estructuras (comúnmente árboles), que son más útiles para el posterior análisis y capturan la jerarquía implícita de la entrada. Un analizador léxico crea tokens de una secuencia de caracteres de entrada y son estos tokens los que son procesados por el analizador sintáctico para construir la estructura de datos, por ejemplo un árbol de análisis o árboles de sintaxis abstracta 😟
</p>

<p align="justify">
<b>Es decir,</b> para fines prácticos un <b>parser</b> en <i>JSON</i> es intercambiar datos que recibimos de un <i>Servidor Web</i> (pues siempre vienen como un <i>String</i>) a un formato de <i>"Clave":Valor</i> o un formato <i>JSON</i> 😎
</p>

* Tabla Hash:

<p align="justify">
Una <a href="https://es.wikipedia.org/wiki/Tabla_hash">tabla hash</a>, matriz asociativa, mapa hash, tabla de dispersión o tabla fragmentada es una estructura de datos que asocia llaves o claves con valores. La operación principal que soporta de manera eficiente es la búsqueda: permite el acceso a los elementos (teléfono y dirección, por ejemplo) almacenados a partir de una clave generada (usando el nombre o número de cuenta, por ejemplo). Funciona transformando la clave con una función hash en un hash, un número que identifica la posición (casilla o cubeta) donde la tabla hash localiza el valor deseado.
</p>

<p align="justify">
Es sumamente <b>rápida</b> pues es una <i>lista ligada</i>, es decir, una lista ligada es como un array sólo que apunta a su siguiente valor por <b>referencia</b> (a su dirección en <i>memoria</i> directamente).
</p>

<p align="justify">
	Si nos otros conocemos la <b>clave</b> nos evitaremos estar haciendo <i>ciclos</i> para recorrer todos lo elementos y obtendremos directamente el <b>valor</b>.
</p>

## Desarrollo

<p align="justify">
	A continuación basándonos en la <b>experiencia</b> de usuario agregaremos un <i>UIActivityView</i> lo cual nos indica que está cargando. A continuación almacenaremos los datos obtenidos en objetos.
</p>

### Paso 1

Configurando la vista:

* Vamos a *Main.storyboard* en el *Canvas* de nuestro *ViewController* agregaremos un *UIActivityIndicatorView* justo en el centro, nos fijamos que la linea azul vertical y la linea azul horizontal aparezcan y soltamos.

* Agregaremos los siguientes *Constrains*: *Equal Width*, *Equal Height* (para que tengan el mismo ancho y alto), *Center Horizontal In Container*, *Center Vertical In Container*

<p align="center">
  <img src="https://github.com/ginppian/Swift-Modules-Parse-JSON/blob/master/tuto1.png" width="1023" height="586" />
</p>

* Hacemos un *Outlet* a nuestro *ViewController*, lo llamaremos *activity*.

<p align="justify">
Con esto terminamos la <i>vista</i>, podríamos hacer la más detallada, agregando un <i>TableView</i> y desplegar los objetos en ésta, pero para fines prácticos lo desplegaremos en <i>Consola</i> y dejaremos la implementación al caso individual de cada quien.
</p>

Nuestro *ViewController* se ve así:

```
import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet var activity: UIActivityIndicatorView!
    
    let headers: HTTPHeaders = [
        "Content-Type": "application/x-www-form-urlencoded",
        "Accept": "application/json",
        ]
    
    let params : Parameters = ["token": "c31e7cc5503e222a6d2ab594c845730272273a5bdcdbd1b97e29df7e19b3ecdadf021fe6a05a0da5c7046e670d89365181d15d037262822231735da484398578"]
    
    let url = "https://offercity.herokuapp.com/api/mostrarEstablecimiento"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request(self.url, method: .post, parameters: self.params, encoding: URLEncoding.httpBody, headers: self.headers)
            
            .responseJSON(completionHandler: { response in
                print("resquest: \(response.request)")  // original URL request
                print("response: \(response.response)") // URL response
                print("data: \(response.data)")     // server data
                print("result: \(response.result)")   // result of response serialization
                print("result.value: \(response.result.value)")
            })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
```
## Paso 2

*Parseando* nuestro la respuesta de nuestro *request*:

* Eliminamos las impresiona que están dentro de nuestro *CompletionHandler* estas:

```
                print("resquest: \(response.request)")  // original URL request
                print("response: \(response.response)") // URL response
                print("data: \(response.data)")     // server data
                print("result: \(response.result)")   // result of response serialization
                print("result.value: \(response.result.value)")
```

ya vimos que:

```
response.result.value
```

nos imprime todo el array de objetos. Para darle formato JSON primero, instalaremos el siguiente pod:

```
pod 'SwiftyJSON'
```

lo agregamos a nuestro *Podfile* 

```
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'REST' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for REST
  pod 'Alamofire', '~> 4.4'
  pod 'SwiftyJSON'
end
```

y le damos *pod install*

**Nota:** hay veces que debemos cerrar Xcode y abrir el archivo: *.xcworkspace* que nos genera la instalación del *Pod*.

* El siguiente paso es importar: SwiftyJSON

```
import SwiftyJSON
```

si nos aparece un advertencia roja no pasa nada, debemos construir el proyecto para eliminarla.

**¿Qué es?**

[SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) nos ahorra la tarea de estar preguntando por valores *Nil* y manejandolos **estar haciendo los *Castings* adecuados etc. simplemente le pasamos nuestro *response.result.value* y obtenemos nuestro JSON correctamente *parseado*. 

* Ahora que tenemos *SwiftJSON* nos aseguraremos que nuestro *response.result.value* tenga algo, haremos la siguiente pregunta:

```
if((response.result.value) != nil) {
	//Parse JSON
} else {
	//No se descargaron Datos
}
```

* Entonces ya podemos *parsear* nuestro la respuesta a nuestro *request* o *response.result.value*:

```
            .responseJSON(completionHandler: { response in

                //Deserealizacion
                let swiftyJson = JSON(response.result.value!)
                print("swiftyJson: \(swiftyJson)")
                
            })
```

Si corremos el proyecto podremos ver lo siguiente:

<p align="center">
  <img src="https://github.com/ginppian/Swift-Modules-Parse-JSON/blob/master/tuto2.png" width="760" height="402" />
</p>

**¿Qué diferencia hay si hubiésemos dejado el siguiente código?**

```
            .responseJSON(completionHandler: { response in

                print(response.result.value)
   
            })
```

<p align="center">
  <img src="https://github.com/ginppian/Swift-Modules-Parse-JSON/blob/master/tuto3.png" width="760" height="402" />
</p>

La principal **diferencia** es que con el segundo nos otros obtenemos un objeto de *Any* tendríamos que hacerle un cast a un arreglo de objetos de clave:valor *[[String: AnyObject]]*, recorrerlo manejando sus *Nil* etc. 

Éste trabajo nos lo ahorra *SwiftyJSON*, pues el primer código nos regresa un objeto **JSON** como tal, sabiendo que podremos acceder a los datos mediante la estructura *clave:valor* y obtener la información necesaria.








