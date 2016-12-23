import Foundation

// Create an enumeration for the suits of a deck of cards
enum Suit : Int {
    
    // List possible cases
    case clubs = 1, diamonds = 2, hearts = 3, spades = 4
    
    // Computed property to return rank
    // Really just a convenience property to make code more readable, it just returns the raw value of the enumeration case
    var rank : Int {
        switch self {
        default: return self.rawValue
        }
    }
    
    // Computed property to return glyph
    var glyph : Character {
        switch self {
        case .spades: return "♠️"
        case .hearts: return "❤️"
        case .diamonds: return "♦️"
        case .clubs: return "♣️"
        }
    }
    
    // Does one rank (this instance) beat another rank?
    func beats(_ otherSuit: Suit) -> Bool {
        return self.rank > otherSuit.rank
    }
}

// Create a new datatype to represent a playing card
struct Card {
    
    // Properties
    var value : Int
    var suit : Suit
    
    // Computed property to return card name
    var name : String {
        switch value {
        case 1: return "Ace"
        case 2: return "two"
        case 3: return "three"
        case 4: return "four"
        case 5: return "five"
        case 6: return "six"
        case 7: return "seven"
        case 8: return "eight"
        case 9: return "nine"
        case 10: return "ten"
        case 11: return "Jack"
        case 12: return "Queen"
        case 13: return "King"
        default: return "undefined"
        }
    }
    
    // Does the value for this card beat another card?
    func beats(_ otherCard: Card) -> Bool {
        return self.value > otherCard.value
    }
    
    // Initializer accepts arguments to set up this instance of the struct
    init?(value : Int, suit : Int) {
        // Only initialize the card if a valid valid is provided
        if value > 0 && value < 14 {
            self.value = value
            // Assign the correct Suit enumeration case
            switch suit {
            case 1: self.suit = Suit.spades
            case 2: self.suit = Suit.diamonds
            case 3: self.suit = Suit.hearts
            case 4: self.suit = Suit.spades
            default: return nil
            }
        } else {
            return nil
        }
    }
    
}

struct Deck {
    
    // Properties
    var cards : [Card]
    
    // Initializer(s)
    init(acesHigh : Bool = false, withJokers : Bool = false) {
        
        // Initalize the deck of cards
        cards = []
        for suit in 1...4 {
            for value in 1...13 {
                if let newCard = Card(value: value, suit: suit) {
                    cards.append(newCard)
                }
            }
        }
        
    }
    
    // Prints status of the deck
    func status() {
        // Iterate over the deck of cards
        for card in self.cards {
            print("Suit is \(card.suit.glyph) and value is \(card.value)")
        }
    }
    
    // Deals the specified number of cards to a hand
    mutating func deal(_ cardsToDeal : Int) -> [Card]? {
        
        // Track cards left to deal
        var cardsLeftToDeal = cardsToDeal
        
        // Make an array that will be passed back out of the function
        var cardsDealt : [Card] = []
        
        // "Shuffle" the deck and give half the cards to the player
        while cardsLeftToDeal > 0 && self.cards.count > 0 {
            
            // Generate a random number between 0 and the count of cards still left in the deck
            let position = Int(arc4random_uniform(UInt32(self.cards.count)))
            
            // Copy the card in this position to the player's hand
            cardsDealt.append(self.cards[position])
            
            // Remove the card from the deck for this position
            self.cards.remove(at: position)
            
            // We've dealt a card
            cardsLeftToDeal -= 1
            
        }
        
        // Check that we could deal the requested number of cards, otherwise return nil
        if cardsDealt.count < cardsToDeal {
            
            // Return dealt cards to deck
            self.cards.append(contentsOf: cardsDealt)
            
            // Clear cards dealt
            cardsDealt = []
            
            // Return nothing, since we couldn't deal the requested number of cards
            return nil
            
        } else {
            
            // We successfully dealt the right number of cards
            return cardsDealt
        }
        
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

// Structure to define hand
struct Hand {
    
    // Properties
    var hand : [Card]
    var description : String
    var type : String
    var topCard : Card {
        return hand[0]
    }
    
    // Initializer(s)
    init(description : String, type : String) {
        self.hand = []
        self.description = description
        self.type = type
    }
    
    // Print status of this hand
    func status() {
        print("=====================================")
        print("All cards in the \(description)'s \(type) hand are...")
        for (index, card) in hand.enumerated() {
            print("Card \(index + 1) in \(description)'s \(type) hand is a suit of \(card.suit.glyph) and value is \(card.value)")
        }
    }
    
    // Remove the top card of this hand
    mutating func removeTopCard() {
        self.hand.remove(at: 0)
    }
}

// This function handles a war
func playWar(player : inout Hand, computer : inout Hand, playerWar : inout Hand, computerWar : inout Hand) {
    
    // It's a war!
    
    // First, check to see that another war is even playable
    // The card currently in the deck was the cause of the tie, so if that's all the player has left: game over!
    if player.hand.count == 1 {
        
        // Player loses
        computer.hand.append(player.topCard)
        player.removeTopCard()
        print("Computer wins (player out of cards in a war)")
        return
        
    } else if computer.hand.count == 1 {
        
        // Computer loses
        player.hand.append(computer.topCard)
        computer.removeTopCard()
        print("Player wins (computer out of cards in a war)")
        return
        
    } else {
        
        // Play the war
        // Remove the card the was already compared (and caused a war)
        // Add to the "war deck" for each player
        playerWar.hand.append(player.topCard)
        computerWar.hand.append(computer.topCard)
        player.removeTopCard()
        computer.removeTopCard()
        
        // Building player's war hand
        while playerWar.hand.count < 4 && player.hand.count > 1 {
            playerWar.hand.append(player.topCard)
            player.removeTopCard()
        }
        
        // Building computer's war hand
        while computerWar.hand.count < 4 && computer.hand.count > 1 {
            computerWar.hand.append(computer.topCard)
            computer.removeTopCard()
        }
        
        // Show player's war hand
        playerWar.status()
        
        // Show computer's war hand
        computerWar.status()
        
        // Show player's regular hand
        player.status()
        
        // Show computer's regular hand
        computer.status()
        
        // Who won this war?
        if player.topCard.beats(computer.topCard) {
            
            // Player won
            
            // Give cards from both war hands to player
            player.hand.append(contentsOf: playerWar.hand)
            player.hand.append(contentsOf: computerWar.hand)
            
            // Emtpy the war hands
            playerWar.hand = []
            computerWar.hand = []
            
            // Give player the cards from regular deck that were compared
            player.hand.append(computer.topCard)
            player.hand.append(player.topCard)
            computer.removeTopCard()
            player.removeTopCard()
            
        } else if computer.topCard.beats(player.topCard) {
            
            // Computer won
            
            // Give cards from both war hands to computer
            computer.hand.append(contentsOf: playerWar.hand)
            computer.hand.append(contentsOf: computerWar.hand)
            
            // Empty the war hands
            playerWar.hand = []
            computerWar.hand = []
            
            // Give computer the cards from regular deck that were compared
            computer.hand.append(computer.topCard)
            computer.hand.append(player.topCard)
            computer.removeTopCard()
            player.removeTopCard()
            
            
        } else {
            
            //It is another war
            print("It is time for _another_ war!")
            playWar(player: &player, computer: &computer, playerWar: &playerWar, computerWar: &computerWar)
            
        }
        
    }
    
}

// Make a deck of cards
var deck = Deck()

// What does the deck look like?
deck.status()

// Track the result of this game
var game = War()

// Initialize hands
var player = Hand(description: "player", type: "regular")
var computer = Hand(description: "computer", type: "regular")

// Deal 26 cards to the player
if let cards = deck.deal(26) {
    player.hand = cards
} else {
    print("ERROR: Deck ran out of cards.")
    exit(-1)
}

// Deal 26 cards to the computer
if let cards = deck.deal(26) {
    computer.hand = cards
} else {
    print("ERROR: Deck ran out of cards.")
    exit(-1)
}

// Game is about to start
print("==========")
print("Game start")
print("==========")

// This loop will repeat until the player either loses or wins by having all or no cards
while player.hand.count > 0 && player.hand.count < 52 {
    
    // Track result
    game.hands += 1
    
    // Show player's regular hand
    player.status()
    
    // Show computer's regular hand
    computer.status()
    
    // Compare the two cards and print a message saying "Computer won" or "Player won" as appropriate
    if player.topCard.beats(computer.topCard) {
        
        // Player wins
        // Put computer's card at bottom of player's deck
        player.hand.append(computer.topCard)
        // Put player's card at bottom of player's deck
        player.hand.append(player.topCard)
        // Remove the cards we compared from top of each deck
        player.removeTopCard()
        computer.removeTopCard()
        
        // Track result
        game.playerWins += 1
        
    } else if computer.topCard.beats(player.topCard) {
        
        // Computer wins
        // Put player's card at bottom of computer's deck
        computer.hand.append(player.topCard)
        // Put computer's card at bottom of computer's deck
        computer.hand.append(computer.topCard)
        // Remove the cards we compared from top of each deck
        player.removeTopCard()
        computer.removeTopCard()
        
    } else {
        
        // Tie
        
        // It's a war!
        
        // Initialize the decks for war
        var playerWar = Hand(description: "player", type: "war")
        var computerWar = Hand(description: "computer", type: "war")
        
        // Play the war!
        playWar(player: &player, computer: &computer, playerWar: &playerWar, computerWar: &computerWar)
        
    }
    
}

// Show player's regular hand
player.status()

// Show computer's regular hand
computer.status()

// Determine who won in the end
if player.hand.count == 0 {
    print("Computer wins (end of game)")
} else {
    print("Player wins (end of game)")
}

// Print game rseults
game.report()

