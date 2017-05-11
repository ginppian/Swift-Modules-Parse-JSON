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

<p align="justify">
	En iOS nos otros conocemos a las <i>tablas has</i> como <i>Diccionarios (NSDictionary)</i> o <i>KVC (Key Value Coding)</i>.
</p>

## Desarrollo

<p align="justify">
	A continuación basándonos en la <b>experiencia de usuario</b> agregaremos un <i>UIActivityView</i> lo cual nos indica que está cargando. A continuación almacenaremos los datos obtenidos en objetos.
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

*Parseando* la respuesta de nuestro *request*:

* Eliminamos los *print* que están dentro de nuestro *CompletionHandler* estas:

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

[SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) nos ahorra la tarea de estar preguntando por valores *Nil* y manejandolos estar haciendo los *Castings* adecuados etc. simplemente le pasamos nuestro *response.result.value* y obtenemos nuestro JSON correctamente *parseado*. 

* Ahora que tenemos *SwiftJSON* nos aseguraremos que nuestro *response.result.value* tenga algo, haremos la siguiente pregunta:

```
if((response.result.value) != nil) {
	//Parse JSON
} else {
	//No se descargaron Datos
}
```

* Entonces ya podemos *parsear* la respuesta a nuestro *response.result.value*:

```
            .responseJSON(completionHandler: { response in

                //Deserealizacion
                let SwiftyJsonVar = JSON(response.result.value!)
                print("SwiftyJsonVar: \(SwiftyJsonVar)")
                
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

La principal **diferencia** es que con el segundo nos otros obtenemos un objeto de *Any* tendríamos que hacerle un cast a un arreglo de objetos de clave:valor *[[String: AnyObject]]*, manejar sus *Nil* etc. 

Éste trabajo nos lo ahorra *SwiftyJSON*, pues el primer código nos regresa un objeto **JSON** como tal, sabiendo que podremos acceder a los datos mediante la estructura *clave:valor* y obtener la información necesaria.

**Dejaremos SwiftyJSON y usaremos otro método**. 

Como tal SwiftyJSON nos da un objeto de tipo JSON, él cual podriamos recorrerlo he ir guardando los sus valores en objetos. Pero para ahorrarnos este trabajo existe otro *pod*.

*ObjectMapper* como tal le indicamos la estructura de nuestro objeto, las claves y no hay necesidad de *parsear* con esta información *ObjectMapper* nos regresa nuestros objetos ya construidos.

## Paso 3

Construyendo Objetos:

Como tal JSON es un arreglo de objetos [{...},{...},{...}].
Los cuales pueden tener más objetos anidados.
Por esta razón es mejor tratarlos como tal, como *objetos*.

* Si observamos en el paso anterior, nuestro objeto JSON se ve algo así:

```
{
"restaurantes" : [{}, {}, {} ...]
}
```
podemos observar que el objeto *JSON* en este caso llamado *SwiftyJsonVar* posee un objeto, el cual sólo tiene una *clave* que es *restaurantes* y que accede a un *array*:

pero es un *array de objetos* 😨

**Nota:** se le podría decir a quien hizo el *API REST* que me mandara directo todo el *array de objetos* pero para no perder tiempo, haremos uso de otro pod 😏

```
pod 'AlamofireObjectMapper', '~> 4.0'
pod 'ObjectMapper', '~> 2.2'
```

Así que nuestro archivo *Podfile* se vería algo así:

```
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'REST' do
  # Comment the next line if you're not using Swift and don't want to use dynam$
  use_frameworks!

  # Pods for REST
  pod 'Alamofire', '~> 4.4'
  pod 'SwiftyJSON'
  pod 'AlamofireObjectMapper', '~> 4.0'
  pod 'ObjectMapper', '~> 2.2'
end
```

Corremos *pod install*

* ¿Qué es ObjectMapper?

[ObjectMapper](https://github.com/Hearst-DD/ObjectMapper#objectmapper--alamofire) es un framework escrito en Swift que facilita la conversión de JSON a objetos y viceversa.

* ¿Por qué instalamos **AlamofireObjectMapper**?

Porque es una extensión de *Alamofire* que trabaja con *ObjectMapper* juntos.


* Creamos el primer objeto:

```
class Edoardo: Mappable {
    
    var arrayRes: [Restaurantes]!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        arrayRes            <- map["restaurantes"]
    }
}
```

*ObjectMapper* nos pide que tengamos un *init* y que le indiquemos los *atributos* de nuestro objeto y las *claves* de donde obtendremos esos atributos.

**Observar**. Cabe destacar que como tenemos un objeto *embebido* en un *objeto* 🤔 tendremos que crear dos clases. La primera un objeto que haga referencia al otro objeto.

Agregamos nuestra segunda clase:

```
class Restaurantes: Mappable {
    
    var nombre: String!
    var latitud: Double!
    var longitud: Double!
    var id_establecimiento: Int!
    var tmp: Int!
    var descripcion: String!
    var photo: String!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        nombre              <- map["nombre"]
        latitud             <- map["latitud"]
        longitud            <- map["longitud"]
        id_establecimiento  <- map["id_establecimiento"]
        tmp                 <- map["tmp"]
        descripcion         <- map["descripcion"]
        photo               <- map["photo"]
    }
}
```

En nuestro *ComplationHandler* eliminamos el código que estaba con el que usábamos *SwiftyJSON*:

```
            .responseJSON(completionHandler: { response in
                
                //Deserealizacion
                let swiftyJson = JSON(response.result.value!)
                print("swiftyJson: \(swiftyJson)")
                
            })

```

y agregamos este:

```
            .responseObject { (response: DataResponse<Edoardo>) in
                
                let edoardo = response.result.value
                print(edoardo?.arrayRes ?? "valio barriga")
                
                if let restaurantes = edoardo?.arrayRes {
                    for restaurante in restaurantes {
                        print(restaurante.nombre)
                    }
                }

            }
```


Aquí es donde usamos *AlamofireObjectMapper* pues cuando usamos la siguiente función:

```
 Alamofire.request(self.url, method: .post, parameters: self.params, encoding: URLEncoding.httpBody, headers: self.headers)

.responseJSON(completionHandler: {response in

})
.responseString(completionHandler: { response in
 
})
```

podemos usar:

```
.responseJSON
```

o

```
.responseString
```

pero no

```
.responseObject
```

*AlamofireObjectMapper* nos agrega esta opción.

Pueden ver el [tutorial pasado](https://github.com/ginppian/Swift-Modules-Consum-REST-Service-With-POST) para comprobar que no existe ninguna que se llame **.responseObject**.

Al final nuestro código se vería algo así:

```
//
//  ViewController.swift
//  REST
//
//  Created by ginppian on 10/05/17.
//  Copyright © 2017 Nut Systems. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper
import AlamofireObjectMapper

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
            
            .responseObject { (response: DataResponse<Edoardo>) in
                
                let edoardo = response.result.value
                print(edoardo?.arrayRes ?? "valio barriga")
                
                if let restaurantes = edoardo?.arrayRes {
                    for restaurante in restaurantes {
                        print(restaurante.nombre)
                    }
                }

            }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


class Edoardo: Mappable {
    
    var arrayRes: [Restaurantes]!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        arrayRes            <- map["restaurantes"]
    }
}

class Restaurantes: Mappable {
    
    var nombre: String!
    var latitud: Double!
    var longitud: Double!
    var id_establecimiento: Int!
    var tmp: Int!
    var descripcion: String!
    var photo: String!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        nombre              <- map["nombre"]
        latitud             <- map["latitud"]
        longitud            <- map["longitud"]
        id_establecimiento  <- map["id_establecimiento"]
        tmp                 <- map["tmp"]
        descripcion         <- map["descripcion"]
        photo               <- map["photo"]
    }
}
```

Si *construimos* y *corremos* el proyecto podremos ver:

<p align="center">
  <img src="https://github.com/ginppian/Swift-Modules-Parse-JSON/blob/master/tuto4.png" width="763" height="262" />
</p>

😱😱😱 Imprimimos el *nombre* de cada *objeto*. Ya podemos acceder a los *atributos* de cada objeto 😎

## Paso 4

Vista de cargando...

Acaso no habíamos dicho que la **expreiencia de usuario** pues sí llego la hora de poner nuestro activity en marcha:

* Como el activity es una *vista* si corriéramos el *request al servidor* en algún momento haría *crash*. Por eso debemos tener en un *hilo* nuestro *activity* (girando muy bonito) y en *otro hilo* nuestro *Alamofire* descargando el JSON.

```
         DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
                
                
            }
        }
``` 

Por convención (la verdad no sé) nuestro *activity* va en el *hilo* principal, el *main*, siendo así, descargaremos el *request* en el otro hilo, que en este caso tiene prioridad de *background* pero podría dársele una mayor prioridad.

* Ponemos a correr el *activity*, como ya dijimos en el *main thread* o hilo principal:

```
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
                
                self.activity.startAnimating()
                
            }
        }
```

* Descargamos nuestro *request*

```
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            
            Alamofire.request(self.url, method: .post, parameters: self.params, encoding: URLEncoding.httpBody, headers: self.headers)
                
                .responseObject { (response: DataResponse<Edoardo>) in
                    
                    let edoardo = response.result.value
                    print(edoardo?.arrayRes ?? "valio barriga")
                    
                    if let restaurantes = edoardo?.arrayRes {
                        for restaurante in restaurantes {
                            print(restaurante.nombre)
                        }
                    }
                    
            }
            
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
                
                self.activity.startAnimating()
                
            }
        }
```

* Y una vez terminado de descargar, detenemos el *activity*:

```
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            
            Alamofire.request(self.url, method: .post, parameters: self.params, encoding: URLEncoding.httpBody, headers: self.headers)
                
                .responseObject { (response: DataResponse<Edoardo>) in
                    
                    let edoardo = response.result.value
                    print(edoardo?.arrayRes ?? "valio barriga")
                    
                    if let restaurantes = edoardo?.arrayRes {
                        for restaurante in restaurantes {
                            print(restaurante.nombre)
                        }
                    }
             
                    self.activity.stopAnimating()
                    self.activity.isHidden = true
            }
            
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
                
                self.activity.startAnimating()
                
            }
        }
```

Al final nuestro código se vería algo así:

```
import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper
import AlamofireObjectMapper

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
        
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            
            Alamofire.request(self.url, method: .post, parameters: self.params, encoding: URLEncoding.httpBody, headers: self.headers)
                
                .responseObject { (response: DataResponse<Edoardo>) in
                    
                    let edoardo = response.result.value
                    print(edoardo?.arrayRes ?? "valio barriga")
                    
                    if let restaurantes = edoardo?.arrayRes {
                        for restaurante in restaurantes {
                            print(restaurante.nombre)
                        }
                    }
                    
                    self.activity.stopAnimating()
                    self.activity.isHidden = true
            }
            
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
                
                self.activity.startAnimating()
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class Edoardo: Mappable {
    
    var arrayRes: [Restaurantes]!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        arrayRes            <- map["restaurantes"]
    }
}

class Restaurantes: Mappable {
    
    var nombre: String!
    var latitud: Double!
    var longitud: Double!
    var id_establecimiento: Int!
    var tmp: Int!
    var descripcion: String!
    var photo: String!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        nombre              <- map["nombre"]
        latitud             <- map["latitud"]
        longitud            <- map["longitud"]
        id_establecimiento  <- map["id_establecimiento"]
        tmp                 <- map["tmp"]
        descripcion         <- map["descripcion"]
        photo               <- map["photo"]
    }
}
```

<p align="center">
  <img src="https://github.com/ginppian/Swift-Modules-Parse-JSON/blob/master/tuto6.gif" width="638" height="360" />
</p>

Posterior a esto podríamos desplegarlo en *TableView* o guarda con *CoreData*.

### Conclusiones

* El uso de *pods* nos simplifica ampliamente la vida.

* Primero debemos hacer un *parse* a JSON y después podremos almacenarlos en objetos. 

* Podríamos evitarlo pasar nuestro *parse* a un *objeto* y hacer código *spaguetti*, por ejemplo guardar nuestro arreglo de objetos [{...},{...},{...}] es una variable global de tipo:

```
var arrayGlobal = [[String:AnyObject]] 
```

y de esta manera, si usamos por ejemplo *TableView* en el método *cellForRowAtIndexPath* ahí podríamos poner algo como:

```
func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier", forIndexPath: indexPath) as UITableViewCell

				var objeto = self.arrayGlobal[indexPath.row]        
    		let nombre = objeto["nombre"] as? String

        //Nombre
        if nombre != nil {
            
            cell.titulo.text = nombre
            
        } else {
            
            cell.titulo.text = ""
            
        }

    return cell
}
```

Esto presenta varias desventajas: continuamente se estará ejecutando esas operaciones en vez de una sola vez, a la larga se volverá difícil de mantener ese código, no podemos usar la información en otras funciones, etc.

La recomendación es tratar a los objetos JSON como *objetos*.

* Existen otros *pods* como [HandyJSON](https://github.com/alibaba/HandyJSON) que también nos permite pasar nuestro JSON a Objeto. Aun que *Alamofire* nos permite recibir la *respuesta* o *response* en un *String*:

```
                .responseString(completionHandler: { response in
                //Do something...
                })
```

La desventaja para este ejemplo es que *HandyJSON* como tal necesita una cadena con caracteres (por eso las '\'):

```
let jsonString = "{\"doubleOptional\":1.1,\"stringImplicitlyUnwrapped\":\"hello\",\"int\":1}"
```

inclusive puede manejar un arreglo de objetos:

```
let jsonArrayString: String? = "[{\"name\":\"Bob\",\"id\":\"1\"}, {\"name\":\"Lily\",\"id\":\"2\"}, {\"name\":\"Lucy\",\"id\":\"3\"}]"
if let cats = [Cat].deserialize(from: jsonArrayString) {
    cats.forEach({ (cat) in
        // ...
    })
}
```

pero para este ejemplo no era útil pues nuestro objeto tenía anidado a un objeto, hubiera sido muy difícil acceder a los *atributos* (nombre, apellido, descripción, etc.) de cualquier objeto *n* del array. La opción más fácil fue la representación de un objeto que anidara otro objeto.

### Contacto

Twitter: @ginppian


