import os
import json


def get_content_from_file_json(name_file, mode="r"):

    
    """
    #get the content of a file

    #Parameters:
    #   name_file: the name of the file / path of the file

    #Returns:
    #    the content if file exists and is not empty, None otherwise
    """
    
    if (not is_file_exist(name_file) or is_file_empty(name_file)):
        
        return
    
    with open(name_file, mode, encoding="utf-8") as file_txt:
        
        return json.load(file_txt)
        
    

def set_content_in_file_json(name_file, content_json, mode="w"):
    
    """
    #set the content of a file

    #Parameters:
    #   name_file: the name of the file / path of the file

    #Returns:
    #    None
    """
    
    with open(name_file, mode, encoding="utf-8") as file_txt:    
        
        json.dump(content_json, file_txt, indent=5)




def check_and_convert(**kwargs):
    
    """
    #check if the parameters passed are correct

    #Parameters:
    #   **Kwargs: the parameters passed
        -> len(kwargs) == 1 if -> the sub-case 'quantity' referer to the case of 'sell_function()'
                               -> the sub-case 'response' referer to the case of 'vendita' in the main function 
        
        -> len(kwargs) == 3 if ' check_and_convert' is called by 'add_function()'

    #Returns:
    #    the value converted if is passed correct or None otherwise
    """
    
   
    if len(kwargs) == 1:
        
        if "quantity" in kwargs.keys():
            
            if not is_int(kwargs["quantity"]) or int(kwargs["quantity"]) < 0:
                print("La quantità deve essere un intero positivo")
                return
            else:
                return int(kwargs["quantity"])
            
        if "response" in kwargs.keys():
            
            if kwargs["response"].lower() != "si" and kwargs["response"].lower() != "no":
                print("La risposta deve essere 'Si' o 'No' ")
                return
            else:
                return 1 if kwargs["response"].lower() == "si"  else 0
            
    
    if len(kwargs) == 3:
        
        if not is_int(kwargs["quantity"]) or int(kwargs["quantity"]) < 0:
            print("La quantità deve essere un intero positivo")
            return
            
              
        elif not is_float(kwargs["buy_price"]) or float(kwargs["buy_price"]) < 0:
            print("Il prezzo di acquisto deve essere un 'float' positivo") 
            return
        
        elif not is_float(kwargs["sell_price"]) or float(kwargs["sell_price"]) < 0:
            print("Il prezzo di vendita deve essere un 'float' positivo")
            return
        
        else:
            return int(kwargs["quantity"]), float(kwargs["buy_price"]), float(kwargs["sell_price"])



def is_file_exist(name_file):
    
    """
    #verify if the path passed rapresent a file

    #Parameters:
    #   name_file: the name of the file / path of the file

    #Returns:
    #    True (bool): if path rapresent a file
    """
   
    return os.path.isfile(name_file)



def is_file_empty(name_file):
    
    """
    #verify if the file passed is empty

    #Parameters:
    #   name_file: the name of the file / path of the file

    #Returns:
    #    True (bool): if file is empty
    """
    
    return bool(os.stat(name_file).st_size == 0)



#deprecate
#use while for dynamic length for the len(obj)
def delete_duplicate(obj):
    
    """
    #delete duplicate for the parameter passed

    #Parameters:
    #   obj: a list of list

    #Returns:
    #    temp_dict = a dictionary without duplicate and with the quantity aupdate to the correct value
    """
    
    temp_dict = {}
    
    i = 0
    while i < len(obj):
        #dictionary with key the product name and value a list containing quantity, purchase price and sale price
        temp_dict[obj[i][0]] = {"quantity" : obj[i][1], "buy_price" : obj[i][2], "sell_price" : obj[i][3] }

        j = i + 1
        while j < len(obj):
            if obj[i][0] == obj[j][0]:
                temp_dict[obj[i][0]]["quantity"] += obj[j][1]
                obj.pop(j)
            else:
                j += 1
        
        i += 1
        
    return temp_dict
                
        


def is_float(value):
    
    """
    #verify if the value passed is float

    #Parameters:
    #   value: the parameter to check

    #Returns:
    #    True (bool): if value is float
    """
    
    try:
        
        float(value)

        return True
    
    except ValueError:
        
        return False


def is_int(value):
    
    """
    #verify if the value passed is int

    #Parameters:
    #   value: the parameter to check

    #Returns:
    #    True (bool): if value is int
    """
    
    try:
        
        int(value)
        
        return True
    
    except ValueError:
        
        return False
        
 