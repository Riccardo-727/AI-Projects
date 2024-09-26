from Operations import * 
import sys



scelta = None

while scelta != "chiudi":

    scelta = input("Inserisci un comando: ").lower()
    
    match scelta:
        
        case "vendita":
            # records a sale
            sell_function()
                
        case "profitti":
            # shows net and gross profits
            show_profit_function()
    
        case "aggiungi":
            # add a product to the warehouse
            add_function()
        
        case "elenca":
            #lists all products in the warehouse
            show_product_function()
    
        case "aiuto":
            #shows the possible commands
            help_user()
        
        case "chiudi":
            # say goodbye and stop the program
            print("Bye bye")
            sys.exit()

        case _:
            #invalid command
            print("Il comando inserito non è corretto, premere 'aiuto' per vedere i suggerimenti ")






