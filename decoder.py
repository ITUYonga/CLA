
from .isa_table import load_table

class IllegalOpcodeError(Exception):
        pass
class AmbiguousOpcodeError(Exception):
        pass
class DecodedInstruction:
        def __init__(self , word , mnemonic , syntax , fields , entry ):
                self.word = word
                self.mnemonic = mnemonic
                self.syntax = syntax
                self.fields = fields
                self.entry = entry



def decode(word)-> DecodedInstruction:
        instructions = load_table()
        decoded_instruction = None
        masks = [k["mask"] for k in instructions]
        matches = [k["match"] for k in instructions]
        match_count = 0
        for i,(mask,match) in enumerate(zip(masks,matches)):
                        if(word&mask == match):
                                if(match_count +1 >= 2):
                                        raise AmbiguousOpcodeError("Bu word ile eslesen birden fazla komut mevcut")

                                match_count += 1             
                                instruction_mnemonic = instructions[i]["mnemonic"]
                                instruction_syntax = instructions[i]["syntax"]
                                instruction_fields = instructions[i]["fields"]
                                
                                
                                field_values = {}
                               
                                for operand , bit_field in instruction_fields.items():
                                        field_value = 0
                                      
                                        for j in bit_field:
                                                holder = word
                                                for k in range(j):
                                                      holder = holder >> 1

                                                field_value = field_value<<1
                                                field_value += holder % 2        
                                                

                                        field_values[operand] = field_value
                                        
                                decoded_instruction = DecodedInstruction(word , instruction_mnemonic,  instruction_syntax, field_values, instructions[i])


        if decoded_instruction is None:
            raise IllegalOpcodeError("Gecersiz Komut")
        return decoded_instruction





        