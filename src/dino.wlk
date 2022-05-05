import wollok.game.*
    
const velocidad = 250
const velocidad2 = 275


object juego{

	method configurar(){
		game.width(12)
		game.height(8)
		game.title("Dino ArgentinanGame")
		game.addVisual(suelo)
		game.addVisual(patrullero)
		game.addVisual(dino)
		game.addVisual(reloj)
		game.addVisual(policiaPie)
		game.addVisual(helicoptero)
	    game.boardGround("fondo.jpeg")
	    game.onTick(2000, "movimiento", {policiaPie.mover()})              //Para mover el nuevo objeto	
	    game.schedule(5000, {game.say(policiaPie, "Alto policia")})        //Para que el nuevo objeto diga cada 5 segundos la frase
		keyboard.space().onPressDo{ self.jugar()}
		
		game.onCollideDo(dino,{ obstaculo => obstaculo.chocar()})
		
	} 
	
	method    iniciar(){
		dino.iniciar()
		reloj.iniciar()
		patrullero.iniciar()
		policiaPie.iniciar()
		helicoptero.iniciar()
	}
	
	method jugar(){
		if (dino.estaVivo()) 
			dino.saltar()
		else {
			game.removeVisual(gameOver)
			self.iniciar()
		}
		
	}
	
	method terminar(){
		game.addVisual(gameOver)
		patrullero.detener()
		reloj.detener()
		dino.morir()
		policiaPie.detener()
		helicoptero.detener()

	}
	
}

object gameOver {
	method position() = game.center()
	method text() = "GAME OVER"
	method musica(){
		game.sound("policia.mp3").play()
	}
}

object reloj {
	
	var tiempo = 0
	
	method text() = tiempo.toString()
	method position() = game.at(1, game.height()-1)
	
	method pasarTiempo() {
		tiempo = tiempo +1
	}
	method iniciar(){
		tiempo = 0
		game.onTick(100,"tiempo",{self.pasarTiempo()})
	}
	method detener(){
		game.removeTickEvent("tiempo")
	}
}

object patrullero {
	 
	const posicionInicial = game.at(game.width()-1,suelo.position().y())
	var position = posicionInicial

	method image() = "auto.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad,"moverPatrullero",{self.mover()})
	}
	
	method mover(){
		position = position.left(1)
		if (position.x() == -1)
			position = posicionInicial
	}
	
	method chocar(){
		juego.terminar()
		game.say(dino, "te fuiste en cana")
	}
    method detener(){
		game.removeTickEvent("moverPatrullero")
	}
}

object suelo{
	
	method position() = game.origin().up(1)
	
	method image() = "suelo.png"
}


object dino {
	var vivo = true
	var position = game.at(1,suelo.position().y())
	
	method image() = "foto.png.png"
	method position() = position
	
	method saltar(){
		if(position.y() == suelo.position().y()) {
			self.subir()
			game.schedule(velocidad*3,{self.bajar()})
		}
	}
	
	method subir(){
		position = position.up(1)
	}
	
	method bajar(){
		position = position.down(1)
	}
	method morir(){
		game.say(self,"Fuiste")
		vivo = false
	}
	method iniciar() {
		vivo = true
	}
	method estaVivo() {
		return vivo
	}
}
object policiaPie{
	const posicionInicial = game.at(9,suelo.position().y())
	var position = posicionInicial
	method position () = position
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad,"policiaPie",{self.mover()})
	}	
		method mover (){
        position = position.left(1)
		if (position.x() == -1)
			position = posicionInicial
		}
		method chocar(){
			juego.terminar()
			self.musica()
			
		}
		method detener(){
			game.removeTickEvent("policiaPie")
		}
		method musica(){
			game.sound("policia.mp3").play()
		}
		method image()="POLI2.jpg"
		method subir (){
			position = position.up(2)
		}
		}
object helicoptero{
	const posicionInicial = game.at(9,suelo.position().y()+2)
	var position = posicionInicial
	method position () = position
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad,"helicoptero",{self.mover()})
	}	
		method mover (){
        position = position.left(1)
		if (position.x() == -1)
			position = posicionInicial
		}
		method chocar(){
			juego.terminar()
		}
		method detener(){
			game.removeTickEvent("helicoptero")
		}
		method image()="helicoptero.jpg"
		}