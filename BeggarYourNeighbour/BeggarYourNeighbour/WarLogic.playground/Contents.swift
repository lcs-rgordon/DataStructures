//: Playground - noun: a place where people can play

//
//  main.swift
//  BeggarYourNeighbour
//
//  Created by Russell Gordon on 12/14/16.
//  Copyright © 2016 Russell Gordon. All rights reserved.
//

import Foundation

// Print cards in a hand
func status(of hand : [Card], for player : String, type : String) {
    print("=====================================")
    print("All cards in the \(player)'s \(type) hand are...")
    for (index, card) in hand.enumerated() {
        print("Card \(index + 1) in \(player)'s \(type) hand is a suit of \(card.suit.glyph) and value is \(card.value)")
    }
}

// This function handles a war
func playWar(playerHand : inout [Card], computerHand : inout [Card], playerWarHand : inout [Card], computerWarHand : inout [Card]) {
    
    // Top of deck
    let topOfDeck = 0
    
    // It's a war!
    
    // First, check to see that another war is even playable
    // The card currently in the deck was the cause of the tie, so if that's all the player has left: game over!
    if playerHand.count == 1 {
        
        // Player loses
        computerHand.append(playerHand[topOfDeck])
        playerHand.remove(at: topOfDeck)
        print("Computer wins (player out of cards in a war)")
        return
        
    } else if computerHand.count == 1 {
        
        // Computer loses
        playerHand.append(computerHand[topOfDeck])
        computerHand.remove(at: topOfDeck)
        print("Player wins (computer out of cards in a war)")
        return
        
    } else {
        
        // Play the war
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
        if playerHand[topOfDeck].beats(computerHand[topOfDeck]) {
            
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
            
        } else if computerHand[topOfDeck].beats(playerHand[topOfDeck]) {
            
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
    
}

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
            print("Suit is \(card.suit.glyph)) and value is \(card.value)")
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

// Make a deck of cards
var deck = Deck()

// What does the deck look like?
deck.status()

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

// Initialize hands
//create empty array for player hand and computer hand
var playerHand : [Card] = []
var computerHand : [Card] = []

// Deal 26 cards to the player
if let newCards = deck.deal(26) {
    playerHand.append(contentsOf: newCards)
} else {
    print("ERROR: Deck ran out of cards.")
    exit(-1)
}

// Show player's regular hand
status(of: playerHand, for: "player", type: "regular")

// Deal 26 cards to the computer
if let newCards = deck.deal(26) {
    computerHand.append(contentsOf: newCards)
    
} else {
    print("ERROR: Deck ran out of cards.")
    exit(-1)
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
    if playerHand[topOfDeck].beats(computerHand[topOfDeck]) {
        
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
        
    } else if computerHand[topOfDeck].beats(playerHand[topOfDeck]) {
        
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
        
        // It's a war!
        
        // Initialize the decks for war
        var playerWarHand : [Card] = []
        var computerWarHand : [Card] = []
        
        // Play the war!
        playWar(playerHand: &playerHand, computerHand: &computerHand, playerWarHand: &playerWarHand, computerWarHand: &computerWarHand)
        
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

