//
//  CheckColision.swift
//  ArcadeGameTemplate
//
//  Created by Vitor Kalil on 14/12/23.

import SpriteKit
import SwiftUI
import UIKit

extension ArcadeGameScene {
    
    /// MARK: - checkColision FUNCTION.
    /// Gestiona las colisiones entre el jugador y los enemigos o los power ups, ejecutando animaciones para cada una y actualizando el estado del juego y el jugador.
    func checkColision() {
        /* Enemies collision */
        var hitEnemies: [SKSpriteNode] = [] // Arreglo para agregar a todos los enemigos golpeados.
        /* Itera sobre todos los nodos de la escena identificados como "soul" para manejar su colisión con el jugador. */
        enumerateChildNodes(withName:"soul"){ node, _  in
            // Casting explícito del nodo de la función enumerate a SKSpriteNode, almacenado en la constante "enemy"
            let enemy = node as! SKSpriteNode
            // Verificamos si el rectángulo que encierra al enemigo intersecta con el rectángulo que encierra al jugador.
            if CGRectIntersectsRect(CGRect(origin: enemy.frame.origin, size: CGSize(width: 26, height: 28)), self.skeleton.frame) {
                // Añadimos al enemigo a la lista de enemigos golpeados.
                hitEnemies.append(enemy)
            }
        }
        
        /* Comenzamos a procesar la animación de ataque, muerte del soul y eliminación de los enemigos golpeados */
        for enemy in hitEnemies {
            // Acción de nodo para crear una animación.
            let deadAnimationR: SKAction
            // Arreglo de texturas (imágenes) para crear una animación.
            var texturesDead: [SKTexture] = []
            // Agregamos las texturas que tenemos en assets al arreglo que creamos para la animación.
            for i in 0...4 {
                texturesDead.append(SKTexture(imageNamed: "soul_disappear_anim_f\(i)_L"))
            }
            // Llamamos a la animación usando el arreglo de las texturas y un método de SKAction.
            deadAnimationR = SKAction.animate(with: texturesDead, timePerFrame: 0.15)
            
            /* Definimos dos tipos de animaciones para el ataque */
            // Primero verificamos que la animación de ataque no esté activa, para iniciarla.
            if skeleton.action(forKey: "attackAnimation") == nil {
                // Ahora verificamos si el jugador está caminando hacia la derecha.
                if skeleton.action(forKey:"walkingAnimationR") != nil{
                    // Creamos una acción para la animación de ataque.
                    let attackAnimation: SKAction
                    // Creamos un arreglo de texturas para la animación.
                    var textures: [SKTexture] = []
                    // Añadimos las texturas al arreglo de la animación que mira a la derecha.
                    for i in 0...9 {
                        textures.append(SKTexture(imageNamed:"reaper_attack_anim_f\(i)_R"))
                    }
                    // Activamos la animación.
                    attackAnimation = SKAction.animate(with: textures, timePerFrame: 0.1,resize: true, restore: true)
                    // Definimos la llave de la animación de ataque hasta este momento.
                    skeleton.run(attackAnimation, withKey: "attackAnimation")
                    // Aumentamos la vida del jugador después de atacar, *solo una vez*
                    ArcadeGameLogic.shared.increasePlayerHealth()
                    // Retroalimentación háptica.
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                } // Si el jugador no estaba moviéndose a la derecha, entonces se mueve a la izquierda.
                else if skeleton.action(forKey:"walkingAnimationL") != nil {
                    /* Misma lógica que la animación del movimiento a la derecha */
                    let attackAnimation: SKAction
                    var textures:[SKTexture] = []
                    for i in 0...9 {
                        textures.append(SKTexture(imageNamed:"reaper_attack_anim_f\(i)_L"))
                    }
                    attackAnimation = SKAction.animate(with: textures, timePerFrame: 0.1,resize:true, restore: true)
                    skeleton.run(attackAnimation,withKey: "attackAnimation")
                    ArcadeGameLogic.shared.increasePlayerHealth()
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                }
                /* Ahora eliminamos el nodo del enemigo atacado. */
                enemy.removeAllActions()
                // Ejecutamos la animación de eliminación.
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    enemy.run(deadAnimationR) {
                        // Actualizamos el contador que se encuentra en el archivo original.
                        self.soulCount -= 1
                        // Actualizamos el contador de la puntuación que se encuentra en el archivo ArcadeGameLogic.
                        ArcadeGameLogic.shared.currentScore += 1
                        // Registra la nueva puntuación para verificar si es una nueva puntuación máxima.
                        self.registerScore()
                        enemy.removeFromParent()
                    }
                }
            }
        }
        
        /* POWER UPS COLLISION */
        // Arreglo para almacenar los power ups consumidos.
        var hitPowerUps: [SKSpriteNode] = []
        // Iteramos sobre todos los power ups.
        enumerateChildNodes(withName:"powerUpGodSpeed") {node, _  in
            // Hacemos un casting explícito del nodo recibido y lo almacenamos en la constante power.
            let power = node as! SKSpriteNode
            // Revisamos la colisión del jugador con el power up, de manera más directa.
            if CGRectIntersectsRect(power.frame, self.skeleton.frame) {
                // Añadimos el power up consumido al arreglo hitPowerUps
                hitPowerUps.append(power)
                // Llamamos a la función que incrementa la velocidad.
                self.increaseSpeed()
            }
        }
        
        // Después, eliminamos todos las acciones del power up consumido.
        for power in hitPowerUps{
            power.removeAllActions()
            power.removeFromParent()
        }
        
    }
}
