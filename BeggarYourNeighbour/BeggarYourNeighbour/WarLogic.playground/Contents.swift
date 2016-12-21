import Cocoa
import Foundation

// Print cards in a hand
func status(of hand : [Card], for player : String, type : String) {
    print("=====================================")
    print("All cards in the \(player)'s \(type) hand are...")
    for (value, card) in hand.enumerated() {
        print("Card \(value + 1) in \(player)'s \(type) hand is a suit of \(Suit.glyph(forHashValue: card.suit)) and value is \(card.value)")
    }
}

// This function handles a war
func playWar(playerHand : inout [Card], computerHand : inout [Card], playerWarHand : inout [Card], computerWarHand : inout [Card]) {
    
    // Top of deck
    let topOfDeck = 0
    
    // It's a war!
    
    // Remove the card the was already compared (and caused a war)
    // Add to the "war deck" for each player
    playerWarHand.append(playerHand[topOfDeck])
    computerWarHand.append(computerHand[topOfDeck])
    playerHand.remove(at: topOfDeck)
    computerHand.remove(at: topOfDeck)
    
    // Building player's war hand
    while playerWarHand.count < 4 && playerHand.count > 1 {
        playerWarHand.append(playerHand[topOfDeck])
        playerHand.remove(at: topOfDeck)
    }
    
    // Building computer's war hand
    while computerWarHand.count < 4 && computerHand.count > 1 {
        computerWarHand.append(computerHand[topOfDeck])
        computerHand.remove(at: topOfDeck)
    }
    
    // Show player's war hand
    status(of: playerWarHand, for: "player", type: "war")
    
    // Show computer's war hand
    status(of: computerWarHand, for: "computer", type: "war")
    
    // Show player's regular hand
    status(of: playerHand, for: "player", type: "regular")
    
    // Show computer's regular hand
    status(of: computerHand, for: "computer", type: "regular")
    
    // Who won this war?
    if playerHand[topOfDeck].value > computerHand[topOfDeck].value {
        
        // Player won
        
        // Give cards from both war hands to player
        playerHand.append(contentsOf: playerWarHand)
        playerHand.append(contentsOf: computerWarHand)
        
        // Emtpy the war hands
        playerWarHand = []
        computerWarHand = []
        
        // Give player the cards from regular deck that were compared
        playerHand.append(computerHand[topOfDeck])
        playerHand.append(playerHand[topOfDeck])
        computerHand.remove(at: topOfDeck)
        playerHand.remove(at: topOfDeck)
        
    } else if computerHand[topOfDeck].value > playerHand[topOfDeck].value {
        
        // Computer won
        
        // Give cards from both war hands to computer
        computerHand.append(contentsOf: playerWarHand)
        computerHand.append(contentsOf: computerWarHand)
        
        // Empty the war hands
        playerWarHand = []
        computerWarHand = []
        
        // Give computer the cards from regular deck that were compared
        computerHand.append(computerHand[topOfDeck])
        computerHand.append(playerHand[topOfDeck])
        computerHand.remove(at: topOfDeck)
        playerHand.remove(at: topOfDeck)
        
        
    } else {
        
        //It is another war
        print("It is time for _another_ war!")
        playWar(playerHand: &playerHand, computerHand: &computerHand, playerWarHand: &playerWarHand, computerWarHand: &computerWarHand)
        
    }
    
}

// Create an enumeration for the suits of a deck of cards
enum Suit : String {
    
    case hearts     = "❤️"
    case diamonds   = "♦️"
    case spades     = "♠️"
    case clubs      = "♣️"
    
    // Given a value, returns the suit
    static func glyph(forHashValue : Int) -> String {
        switch forHashValue {
        case 0 :
            return Suit.hearts.rawValue
        case 1 :
            return Suit.diamonds.rawValue
        case 2 :
            return Suit.spades.rawValue
        case 3 :
            return Suit.clubs.rawValue
        default:
            return Suit.hearts.rawValue
        }
    }
    
}

// Create a new datatype to represent a playing card
struct Card {
    
    var value : Int
    var suit : Int
    
    // Initializer accepts arguments to set up this instance of the struct
    init(value : Int, suit : Int) {
        self.value = value
        self.suit = suit
    }
    
}

// Create a new datatype to represent a game of war
struct War {
    var hands : Int
    var playerWins : Int
    
    // Default values for initializer
    init(hands : Int = 0, playerWins : Int = 0) {
        self.hands = hands
        self.playerWins = playerWins
    }
    
    // Report results
    func report() {
        print("===================")
        print("Game results are...")
        print("\(self.hands) total hands played")
        print("Player won \(self.playerWins) hands")
        print("Computer won \(self.hands - self.playerWins) hands")
    }
}

// Track the result of this game
var game = War()

// Initalize a deck of cards
var deck : [Card] = []      // creates an empty deck
for suit in 0...3 {
    for value in 1...13 {
        var myCard = Card(value: value, suit: suit)
        deck.append(myCard)
    }
}

// Iterate over the deck of cards
for card in deck {
    print("Suit is \(Suit.glyph(forHashValue: card.suit)) and value is \(card.value)")
}

// Initialize hands
//create empty array for player hand and computer hand
var playerHand : [Card] = []
var computerHand : [Card] = []

// "Shuffle" the deck and give half the cards to the player
while deck.count > 26 {
    
    // Generate a random number between 0 and the count of cards still left in the deck
    var position = Int(arc4random_uniform(UInt32(deck.count)))
    
    // Copy the card in this position to the player's hand
    playerHand.append(deck[position])
    
    // Remove the card from the deck for this position
    deck.remove(at: position)
    
}

// Show player's regular hand
status(of: playerHand, for: "player", type: "regular")

// "Shuffle" the deck and give half the cards to the computer
while deck.count > 0 {
    
    // Generate a random number between 0 and the count of cards still left in the deck
    var position = Int(arc4random_uniform(UInt32(deck.count)))
    
    // Copy the card in this position to the computer's hand
    computerHand.append(deck[position])
    
    // Remove the card from the deck for this position
    deck.remove(at: position)
    
}

// Show computer's regular hand
status(of: computerHand, for: "computer", type: "regular")

// Declare a constant for the top of the "deck" (0th element in array)
let topOfDeck = 0

// This loop will repeat until the player either loses or wins by having all or no cards
while playerHand.count > 0 && playerHand.count < 52 {
    
    // Track result
    game.hands += 1
    
    // Show player's regular hand
    status(of: playerHand, for: "player", type: "regular")
    
    // Show computer's regular hand
    status(of: computerHand, for: "computer", type: "regular")
    
    // Compare the two cards and print a message saying "Computer won" or "Player won" as appropriate
    if playerHand[topOfDeck].value > computerHand[topOfDeck].value {
        
        // Player wins
        // Put computer's card at bottom of player's deck
        playerHand.append(computerHand[topOfDeck])
        // Put player's card at bottom of player's deck
        playerHand.append(playerHand[topOfDeck])
        // Remove the cards we compared from top of each deck
        playerHand.remove(at: topOfDeck)
        computerHand.remove(at: topOfDeck)
        
        // Track result
        game.playerWins += 1
        
    } else if playerHand[topOfDeck].value < computerHand[topOfDeck].value {
        
        // Computer wins
        // Put player's card at bottom of computer's deck
        computerHand.append(playerHand[topOfDeck])
        // Put computer's card at bottom of computer's deck
        computerHand.append(computerHand[topOfDeck])
        // Remove the cards we compared from top of each deck
        playerHand.remove(at: topOfDeck)
        computerHand.remove(at: topOfDeck)
        
    } else {
        
        // Tie
        
        // Do both players have at least more then 0 cards so that they can play a war?
        if playerHand.count == 0 {
            
            // Player loses
            print("Computer wins (player out of cards in a war)")
            break
            
        } else if computerHand.count == 0 {
            
            // Computer loses
            print("Player wins (computer out of cards in a war)")
            break
            
        } else {
            
            // It's a war!
            
            // Initialize the decks for war
            var playerWarHand : [Card] = []
            var computerWarHand : [Card] = []
            
            // Play the war!
            playWar(playerHand: &playerHand, computerHand: &computerHand, playerWarHand: &playerWarHand, computerWarHand: &computerWarHand)
            
        }
        
    }
    
}

// Show player's regular hand
status(of: playerHand, for: "player", type: "regular")

// Show computer's regular hand
status(of: computerHand, for: "computer", type: "regular")

// Determine who won in the end
if playerHand.count == 0 {
    print("Computer wins (end of game)")
} else {
    print("Player wins (end of game)")
}

// Print game rseults
game.report()




