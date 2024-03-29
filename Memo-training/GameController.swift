//
//  GameController.swift
//  Memo-training
//
//  Created by Víctor Agulló on 18/10/19.
//  Copyright © 2019 Eztena. All rights reserved.
//

import UIKit

class GameController: UIViewController {
    
    // Enlace débil de los botones
    @IBOutlet weak var blue: UIButton!
    @IBOutlet weak var red: UIButton!
    @IBOutlet weak var green: UIButton!
    @IBOutlet weak var yellow: UIButton!
    
    // Array de los botones en pantalla
    var buttonsArray:[UIButton] = []
    
    // Array con el patrón a seguir
    var pattern:[UIButton] = []
    
    // Array con los intentos del usuario
    var userTry:[UIButton] = []
    
    // Dificultad por defecto
    var difficulty:Int = 0
    
    // Retraso entre rondas
    var totalDelay = 0.4
    
    // Retraso acumulativo entre pistas de luz
    var progressiveDelay = 0.4
    
    // Variable del nombre traida del código de Principal
    var name = ""
    
    // Variable para el color de cada botón
    var initialColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    // Variable para el cambio de color al pulsar
    var changeColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    // Se inicia el juego al cargar la pantalla
    override func viewDidLoad() {
        super.viewDidLoad()
        startGame()
    }
    
    /*
    Mete los botones en el array, llama a la función Shuffle y mete el resultado
    en el array pattern, que marca el patrón de botones a pulsar, luego llama a
    gamble, usando el patrón generado
     */
    func startGame() {
        buttonsArray.append(blue)
        buttonsArray.append(red)
        buttonsArray.append(green)
        buttonsArray.append(yellow)
        
        let pattern = shuffle(buttons: buttonsArray)
        
        gamble(pattern: pattern)
    }
    
    /*
     En cada iteración, cuyo alcance varía según la diferencia entre la dificultad
     y el tamaño del patrón actual, se van escogiendo los botones aleatoriamente
     del array rellenado en startGame() para meterlos en el patrón a seguir al jugar,
     que es devuelto.
     */
    func shuffle(buttons: [UIButton]) -> [UIButton] {
        let numberOfIteration = difficulty - pattern.count
        
        /*
         Mediante el for se van pasando botones aleatorios desde su array a otro que representa
         el patrón a seguir. Es más útil que un while por la preparación que tiene el for
         para iterar objetos.
         */
        for _ in 0..<numberOfIteration {
            let randomButton = buttonsArray.randomElement()
            
            pattern.append(randomButton!)
        }
        return pattern
    }
    
    /*
     Se itera el array con el patrón a mostrar en pantalla con un retraso
     tras cada iteración para que no se muestren todas a la vez.
     */
    func gamble(pattern: [UIButton]) {
        totalDelay = 0
        
        /*
         El uso de un bucle for en lugar de un foreach responde a la necesidad
         de iterar los elementos del array recibido e ir utilizando cada elemento
         por separado.
         */
        for button in pattern {
            totalDelay += progressiveDelay
            
            /*
            En lugar de usar el DispatchQueue se usará el Timer,
            por un problema al ejecutarse que hacía que varios botones se activaban a la vez
             */
            Timer.scheduledTimer(withTimeInterval: totalDelay, repeats: false) {
                (delay) in self.switchButton(randomButton: button)
            }
        }
    }
    
    // Se ilumina y apaga el botón especificado por la iteración de gamble()
    func switchButton(randomButton: UIButton) {

        randomButton.isHighlighted = true
        randomButton.isHighlighted = false
    }
    
    /*
     Función que permite el paso de variables y constantes entre pantallas, en este
     caso se quieren pasar el nombre transmitido desde la vista Principal y la puntuación
     obtenida tras perder en esta vista hacia GameOver.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        /*
         El prepare resulta el método más sencillo para pasar datos entre pantallas, crea
         una variable que tiene acceso a los atributos de la pantalla importada para darles
         otros valores.
         */
        if segue.destination is GameOverController
        {
            let destinyGameOver = segue.destination as? GameOverController
            
            destinyGameOver?.playerName = name
            destinyGameOver?.playerScore = difficulty
        }
    }
    
    /*
    Botones que añaden su información al array de intentos de usuario y luego los mandan
    a la función lose() para saber si el usuario pasa a la siguiente ronda o pierde
    */
    @IBAction func blue(_ sender: UIButton) {
        initialColor = #colorLiteral(red: 0, green: 0, blue: 0.7843137255, alpha: 1)
        changeColor =  #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        switchColor(button: blue, color1: initialColor, color2: changeColor)
        userTry.append(blue)
        lose(pattern: pattern)
    }
    
    @IBAction func red(_ sender: UIButton) {
        initialColor = #colorLiteral(red: 0.7843137255, green: 0, blue: 0, alpha: 1)
        changeColor =  #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        switchColor(button: red, color1: initialColor, color2: changeColor)
        userTry.append(red)
        lose(pattern: pattern)
    }
    
    @IBAction func green(_ sender: UIButton) {
        initialColor = #colorLiteral(red: 0, green: 0.7843137255, blue: 0, alpha: 1)
        changeColor =  #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        switchColor(button: green, color1: initialColor, color2: changeColor)
        userTry.append(green)
        lose(pattern: pattern)
    }
    
    @IBAction func yellow(_ sender: UIButton) {
        initialColor = #colorLiteral(red: 0.7843137255, green: 0.7843137255, blue: 0, alpha: 1)
        changeColor =  #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        switchColor(button: yellow, color1: initialColor, color2: changeColor)
        userTry.append(yellow)
        lose(pattern: pattern)
    }
    
    /*
     Cambio de color de los botones pulsados como método de feedback visual
     tras pulsar un botón y distinguir la participación del jugador de la
     guía de la maquina.
     */
    func switchColor(button: UIButton, color1: UIColor, color2: UIColor) {
        
        button.backgroundColor = color2
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) {
            (delay) in button.backgroundColor = color1
        }
    }
    
    /*
     Función independiente del startGame() que es llamada por los botones
     de la pantalla para comprobar si el usuario ha superado la ronda actual,
     en caso contrario pasa a la siguiente pantalla.
     */
    func lose(pattern: [UIButton]) {
        
        // Pulsación del botón guardada en el array
        let tryIndex = userTry.count - 1
        
        /*
         Comparación, usando la long. del array de pulsaciones, con la
         posición del array patrón para que así cada pulsación sea comparada
         individualmente y si se falla en una, se pierda inmediatamente.
         */
        if userTry[tryIndex] != pattern[tryIndex] {
                /*
                 Se realiza el segue programáticamente en lugar
                 del modelo visual por su mayor versatilidad, en este caso
                 pudienddo elegir hacerlo tras comprobar que el usuario ha perdido.
                 */
            performSegue(withIdentifier: "segueGameOver", sender: self)
        } else if userTry.count == pattern.count{
            self.difficulty += 1
            self.userTry = []
                
            startGame()
        }
    }
}
