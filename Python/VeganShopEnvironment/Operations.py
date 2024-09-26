import json
import Utils as utls


def add_function():
    
    """
    first check if the input is correct and then
    adds the indicated product to the store for the indicated quantity, purchase price and selling price

    #Parameters:
    #    name (str): the name of the product
    #    quantity (int): the quantity of the product
    #    buy_price (float): the purchasing price of the product
    #    sell_price (float): the selling price of the product
   

    #Returns:
    #    None
    """

    
    
    name = input("Nome del prodotto: ")
    
    while(name == ""):
        name = input("Nome del prodotto: ")
    
    products_in_shop = utls.get_content_from_file_json("Lista Prodotti.txt")
    
    result1 = utls.check_and_convert(quantity = input("Quantità: "), buy_price = input("Prezzo di acquisto: "), sell_price = input("Prezzo di vendita: ")) if products_in_shop == None or not name in products_in_shop.keys()  else utls.check_and_convert(quantity = input("Quantità: "))          
 
    while(result1 == None):
        result1 = utls.check_and_convert(quantity = input("Quantità: "), buy_price = input("Prezzo di acquisto: "), sell_price = input("Prezzo di vendita: ")) if products_in_shop == None or not name in products_in_shop.keys()  else utls.check_and_convert(quantity = input("Quantità: "))          
    

    if type(result1) == int:
        quantity = result1
    else:
        quantity, buy_price, sell_price = result1
        
    
    
    if products_in_shop == None:
        
        first_product = { name : {"quantity" : quantity, "buy_price" : buy_price, "sell_price" : sell_price}}
        
        utls.set_content_in_file_json("Lista Prodotti.txt", first_product)   
        
        print(f"AGGIUNTO {quantity} X {name}")
        
        return
    
    
    
    if name in products_in_shop:
        
        products_in_shop[name] ["quantity"] += quantity
        
    else:
        
        products_in_shop[name] = {"quantity" : quantity, "buy_price" : buy_price, "sell_price" : sell_price}

    utls.set_content_in_file_json("Lista Prodotti.txt", products_in_shop)

    print(f"AGGIUNTO {quantity} X {name}")




def sell_function():
    
    """
    first check if the input is correct and then sell the indicated product for the indicated quantity
    if the input is incorrect for a product, the insertion request stops and only the permitted products are sold

    #Parameters:
    #    name (str): the name of the product
    #    quantity (int): the quantity of the product
   
    #Returns:
    None
    
    """
    
    #checks the correctness of the input parameters and adds them to the list

    product_to_sell = []
    
    response = True
    
    while(response):
    
        name = input("Nome del prodotto: ")
        while(name == ""):
            name = input("Nome del prodotto: ")
            
        qnt = utls.check_and_convert(quantity = input("Quantità: ")) 
        while(qnt == None):
            qnt = utls.check_and_convert(quantity = input("Quantità: ")) 
            
        product_to_sell.append((name, qnt))
        
        response = utls.check_and_convert(response = input("Aggiungere un altro prodotto ? (Si/No): "))
        while(response == None):
            response = utls.check_and_convert(response = input("Aggiungere un altro prodotto ? (Si/No): "))
    

    #see also this operator:->  any(x[i] == "something" for x in collezzione) -> verify the condition    


    
    products_in_shop = utls.get_content_from_file_json("Lista Prodotti.txt")
    
    if products_in_shop == None:
        
        print("Non ci sono ancora prodotti nel negozio")
        
        return

        
  
    #products sold in the single sale
    prods_selled = [] 
    
    #total products sold so far
    total_prods_selled = utls.get_content_from_file_json("Totale Prodotti Venduti.txt")
    
    if total_prods_selled == None:
        
        total_prods_selled = {}
        
    
    for prods in product_to_sell:
        
        if prods[0] in products_in_shop.keys():
            
            if products_in_shop[prods[0]]["quantity"] - prods[1] >= 0:
                
                products_in_shop[prods[0]]["quantity"] -= prods[1]
                
                if prods[0] in total_prods_selled:
                    
                    total_prods_selled[prods[0]]["quantity"] += prods[1]
                    
                    prods_selled.append( (prods[0], prods[1], products_in_shop[prods[0]]["sell_price"] ))
                
                else:
                    
                    total_prods_selled[prods[0]] = {"quantity" : prods[1], "buy_price" : products_in_shop[prods[0]]["buy_price"], "sell_price" : products_in_shop[prods[0]]["sell_price"]}
                    
                    prods_selled.append( (prods[0], prods[1], products_in_shop[prods[0]]["sell_price"] ))
                
            
            else:
                
                print(f"La quantità inserita supera la quantita attualmente presente per il prodotto {prods[0]}")
                
        else:
            
            print(f"Il prodotto {prods[0]} che vuoi vendere non è presente in magazzino")
            
    
    #update the file with the permitted sell
    utls.set_content_in_file_json("Lista Prodotti.txt", products_in_shop)
    
    #save sell ina separate file
    utls.set_content_in_file_json("Totale Prodotti Venduti.txt", total_prods_selled)
    
    total_profit = 0
    
    for indice, tpl in enumerate(prods_selled):
        
        if indice == 0:
            print("VENDITA REGISTRATA")
        
        print(f"{tpl[1]} X {tpl[0]}: € {tpl[2]} ")
        
        total_profit += tpl[1] * tpl[2]
        
    print(f"Totale: {total_profit:.2f}")
    
    return

        


def show_profit_function():
      
    """
    shows the profit made so far

    #Parameters:
    #   None
    
    #Returns:
    None
    
    """
    
    products_selled = utls.get_content_from_file_json("Totale Prodotti Venduti.txt")
    
    if products_selled == None:
        
        print("Non puoi calcolare il profitto perchè non hai ancora realizzato vendite")
    
        return


    total_profit = 0
    
    total_cost = 0
    
    for sales in products_selled:

        total_profit += products_selled[sales]["sell_price"] * products_selled[sales]["quantity"]
        
        total_cost += products_selled[sales]["buy_price"] * products_selled[sales]["quantity"]

    
    print(f"Profitto: lordo = €{total_profit} netto = €{total_profit - total_cost}")
    


    

def show_product_function():
    
    """
    shows all products in the shop

    #Parameters:
    #   None
    
    #Returns:
    None
    
    """
    
    products_to_show = utls.get_content_from_file_json("Lista Prodotti.txt")
    
    if products_to_show == None:
        
        print("Non ci sono ancora prodotti in negozio")
    
        return
    
    print("PRODOTTO QUANTITA' PREZZO")
    
    for sales in products_to_show:

       print(f"{sales} {products_to_show[sales]['quantity']} {products_to_show[sales]['sell_price']}")
    
    
    
def help_user():
    
    """
    get the program instructions

    #Parameters:
    #   None
    
    #Returns:
    None
    
    """
    
    print("\nQuesto progetto consiste nel realizzare un software per la gestione di un negozio di prodotti vegani. \n\n" +
           "Premi: \n\n" +
           "'aggiungi': Per registrare nuovi prodotti, con nome, quantità, prezzo di vendita e prezzo di acquisto. \n" +
           "'elenca':   Per ottenere un elenco di tutti i prodotti presenti. \n" +
           "'vendita':  Per registrare le vendite effettuate. \n" +
           "'profitti': Per mostrare i profitti lordi e netti. \n" +
           "'aiuto':    Per mostrare un menu di aiuto con tutti i comandi disponibili.")
    
    
    