"""

    The idea here is that we'd read something like (x - 2) * ((x / 3) + 40)
    Assume the Position is 0 to begin with (the result will go here)

    The script will understand the first term as 0 + f(x)
    
    THe brackets will increment the priority and an effective new string decode begins
    Closed brackts indicate the end of the clause and the definition of the value inside.

    Once every letter has been acknowledged 

    TODO: If no Oper, use Multiply
"""

def decode(math : str) -> str:

    variables : list = []       # begin with no ca65 variables
    priority  : int  = 0        # current ca65 variable to access




    return