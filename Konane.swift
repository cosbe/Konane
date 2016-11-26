enum KonaneColor {
    case black, white, empty
} 

class KonaneGame {
    private var gameState = KonaneGameState()  
    private let blackInputSource: KonaneMoveInputSource
    private let whiteInputSource: KonaneMoveInputSource
    
    init(blackIsHuman: Bool, whiteIsHuman: Bool) {
        if blackIsHuman {
            blackInputSource = KonaneMoveInputSourceHuman(isBlack: true)
        } else {
            blackInputSource = cosbe_KonaneMoveInputSourceAI(isBlack: true)
        }

        if whiteIsHuman {
            whiteInputSource = KonaneMoveInputSourceHuman(isBlack: false)
        } else {
            whiteInputSource = cosbe_KonaneMoveInputSourceAI(isBlack: false)
        }
   } 

    func play () -> Bool{
        let blackRemoveCoordinates: (x: Int, y: Int) = blackInputSource.removeFirstPiece(gameState: gameState)
        gameState.perform(blackRemove: (x: blackRemoveCoordinates.0, y: blackRemoveCoordinates.1)) 
        self.displayBoard()

        let whiteRemoveCoordinates: (x: Int, y: Int) = whiteInputSource.removeSecondPiece(gameState: gameState)
        gameState.perform(whiteRemove: (x:whiteRemoveCoordinates.0, y:whiteRemoveCoordinates.1))
        self.displayBoard() 
        
        var nextMove: KonaneMove 

        // if no one has won yet
        while !gameState.didBlackWin() && !gameState.didWhiteWin() {
            if gameState.getIsBlackTurn() {
                nextMove = blackInputSource.nextMove(gameState: gameState) 
            } else {
                nextMove = whiteInputSource.nextMove(gameState: gameState)
            }
            gameState.perform(move: nextMove)
            self.displayBoard() 
        }
                

        if gameState.didBlackWin() {
            return true
        } else {
            return false
        }
    }
    
    

    func displayBoard () {
        var rowValues: String = ""
        for rowNumber in (0..<gameState.getBoardHeight()).reversed() { 
            for columnNumber in 0..<gameState.getBoardWidth(){ 
                switch (gameState.color(atX: rowNumber, atY: columnNumber)){
                    case .black: 
                        rowValues.append("  X")  
                    case .white:
                        rowValues.append("  O")
                    case .empty:
                        rowValues.append("   ")
                }
            } 

            print (rowValues)
            rowValues = ""
        }
    }
}

class KonaneGameState {
    let width: Int = 16
    let height: Int = 16

    private var board: [[KonaneColor]] 
    var isBlackTurn: Bool = true

    //beginning game board
    init () { 
        board = [[KonaneColor]](repeating: [KonaneColor](repeating: .empty, count:width), count: height)
        
        for rowNumber in 0..<height { 
            for columnNumber in 0..<width {
                if (rowNumber % 2 == 0 && columnNumber % 2 == 0) || (rowNumber % 2 == 1 && columnNumber % 2 == 1) { 
                    board[rowNumber][columnNumber] = .black
        
                } else {                  
                    board[rowNumber][columnNumber] = .white 
                }    
             }
        }
    }


    func getBoardWidth () -> Int {
        // allows width and height to be used outside of KonaneGameState

        return width
    }

    func getBoardHeight () -> Int {
        return height
    }

    func getIsBlackTurn() -> Bool { 
        return isBlackTurn
    } 
    
    // Player inputs coordinates for piece move
    func color(atX: Int, atY: Int) -> KonaneColor {
        return board[atX][atY] 
    }

    func isValid(move: KonaneMove) -> Bool {
        print("Did not do yet")
        return true
    }

    func isValid(blackRemove: (x: Int, y: Int)) -> Bool {
        if blackRemove == (0, 0) || blackRemove == (15, 0) || blackRemove == (0, 15) || blackRemove == (15, 15) || blackRemove == (7, 7) {
            return true
        } else {
            return false
        }
    }

    func isValid(whiteRemove: (x: Int, y: Int)) -> Bool {
   
    }

    func perform(move: KonaneMove) {
        if isValid(move: move) {
            if move.fromX < move.toX {
                for x in move.fromX ... move.toX {
                    board[x][move.fromY] = .empty
                } 
            } else if move.fromX > move.toX {
                for x in move.toX ... move.fromX {
                    board[x][move.fromY] = .empty
                } 
            } else if move.fromY < move.toY {
                for y in move.fromY ... move.toY {
                    board[move.fromX][y] = .empty
                }
            } else if move.fromY > move.toY {
                for y in move.toY ... move.fromY {
                    board[move.fromX][y] = .empty
                }
            } 

            if isBlackTurn == true {
                board[move.toX][move.toY] = .black
                isBlackTurn = false
            } else {
                board[move.toX][move.toY] = .white
                isBlackTurn = true
            } 
        } else {
            print ("Your move is invalid. Please input a valid move.")
        }
    }  

    func perform(blackRemove: (x: Int, y: Int)) {
        if isValid(blackRemove: blackRemove) {
            board[blackRemove.x][blackRemove.y] = .empty
            isBlackTurn = false
        }   
    } 

    func perform(whiteRemove: (x: Int, y: Int)) {
        if isValid(whiteRemove: whiteRemove){
            board[whiteRemove.x][whiteRemove.y] = .empty
            isBlackTurn = true
        } else {
            print ("Your move is invalid. Please input a valid move.")
        }
    } 


    func didBlackWin() -> Bool {
        print("Didn't do yet")
        return false
    } 
    
    func didWhiteWin() -> Bool {
        print("Didn't do yet")
        return false
    } 
}


class KonaneMove {
    var fromX: Int
    var fromY: Int
    var toX: Int
    var toY: Int
    
    init(fromX: Int, fromY: Int, toX: Int, toY: Int) {
        self.fromX = fromX
        self.fromY = fromY
        self.toX = toX
        self.toY = toY
    }
}

class KonaneMoveInputSource {
    private var isBlack: Bool

    init(isBlack: Bool) {
        self.isBlack = isBlack
    }

   func removeFirstPiece(gameState: KonaneGameState) -> (x: Int, y: Int){
        fatalError("Please override this")
    }

   func removeSecondPiece(gameState: KonaneGameState) -> (x: Int, y: Int){
        fatalError("Please overrid this")
    }

   func nextMove(gameState: KonaneGameState) -> KonaneMove{
       fatalError("Please override this")
    }
} 

class KonaneMoveInputSourceHuman:KonaneMoveInputSource {
    override func removeFirstPiece(gameState: KonaneGameState) -> (x: Int, y: Int) {

        print("Black player, please enter the x coordinate of the piece you want to remove.")
        var firstPieceYCoordinate = Int(readLine()!)!

        print("Black player, please enter the y coordinate of the piece you want to remove.")
        var firstPieceXCoordinate = Int(readLine()!)! 

        while !gameState.isValid(blackRemove: (x: firstPieceXCoordinate, y: firstPieceYCoordinate)) {
            print ("Your move is invalid. Please input a valid move. Enter the x coordinate of the piece you want to remove.")     
            firstPieceYCoordinate = Int(readLine()!)!

            print ("Enter the y coordinate of the piece you want to remove.")
            firstPieceXCoordinate = Int(readLine()!)!
        } 

        return (x: firstPieceXCoordinate, y: firstPieceYCoordinate)
    }


    override func removeSecondPiece(gameState: KonaneGameState) -> (x: Int, y: Int) {
        print ("White player, enter the x coordinate of the piece you want to remove.")
        var secondPieceYCoordinate: Int = Int(readLine()!)!

        print ("White player, enter the y coordinate of the piece you want to remove.")    
        var secondPieceXCoordinate: Int = Int(readLine()!)!
        
        while !gameState.isValid( whiteRemove: (x: secondPieceXCoordinate, y: secondPieceYCoordinate)) {
            print ("Your move is invalid. Please enter a valid move. Enter the x coordinate of the piece you want to remove.")
            secondPieceYCoordinate = Int(readLine()!)!

            print ("Enter the y coordinate of the piece you want to remove.")
            secondPieceXCoordinate = Int(readLine()!)!
        } 
        return (x: secondPieceXCoordinate, y:secondPieceYCoordinate)   
    }
 
    override func nextMove(gameState: KonaneGameState) -> KonaneMove {

        if gameState.isBlackTurn {
            print("It is the black player's turn.")
        } else {
            print("It is the white player's turn.")
        }
        
        print ("Player, enter the x coordinate of the piece you want to move.")
        var fromYCoordinate: Int = Int(readLine()!)!

        print ("Player, enter the y coordinate of the piece you want to move.")
        var fromXCoordinate: Int = Int(readLine()!)!

        print ("Player, enter the x coordinate of the place you want to move to.")
        var toYCoordinate: Int = Int(readLine()!)!

        print ("Player, enter the y coordinate of the place you want to move to.")    
        var toXCoordinate: Int = Int(readLine()!)!
        
        var x = KonaneMove(fromX: fromXCoordinate, fromY: fromYCoordinate, toX: toXCoordinate, toY: toYCoordinate)
        
        while !gameState.isValid(move: x) {
            print ("Your move is invalid. Please enter a valid move. Enter the x coordinate of the piece you want to move. As a reminder, X is a black piece and O is a white piece.")
            fromYCoordinate = Int(readLine()!)!

            print ("Enter the y coordinate of the piece you want to move.")
            fromXCoordinate = Int(readLine()!)!

            print ("Enter the x coordinate of the place you want to move to.")
            toYCoordinate = Int(readLine()!)!    

            print ("Enter the y coordinate of the place you want to move to.")
            toXCoordinate = Int(readLine()!)!

            x = KonaneMove(fromX: fromXCoordinate, fromY: fromYCoordinate, toX: toXCoordinate, toY: toYCoordinate)
        }             
        return x
    } 
}

class cosbe_KonaneMoveInputSourceAI:KonaneMoveInputSource {
    override func removeFirstPiece(gameState: KonaneGameState) -> (x: Int, y: Int) {
        print("Did not do yet")

        return (x:0, y:0)    
    }
    
    override func removeSecondPiece(gameState: KonaneGameState) -> (x: Int, y: Int) {
        print("Did not do yet")

        return (x:0, y:0)        
    }
    
    override func nextMove(gameState: KonaneGameState) -> KonaneMove { 
        print("Did not do yet")
        let x = KonaneMove(fromX:0 ,fromY:0, toX:0, toY:0)
        return x
    }

}

// beginning of game

print ("Please enter true if black player is human. Enter false if black player is AI.")
let isBlackPlayerHuman: Bool = Bool(readLine()!)!

print ("Please enter true if white player is human. Enter false if white player is AI.")
let isWhitePlayerHuman: Bool = Bool(readLine()!)!

let game = KonaneGame (blackIsHuman: isBlackPlayerHuman, whiteIsHuman: isWhitePlayerHuman)

game.displayBoard()

if game.play() {
    print("Congratulations Black player, you won!")
} else {
    print("Congratulations White player, you won!")
}

