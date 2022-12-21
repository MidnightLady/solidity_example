import json
import math
from web3 import Web3
from hexbytes import HexBytes

w3: Web3 = Web3(Web3.HTTPProvider('http://127.0.0.1:8545'))

CHAIN_ID = "dev"
CONTRACT_STORAGE = "StorageState"
MAP = json.load(open('build/deployments/map.json'))

MAX_BIT_IN_SLOT = 256
BIT_HEX = 4
MAX_HEX_IN_SLOT = MAX_BIT_IN_SLOT / BIT_HEX

STORAGE_ADDRESS = MAP[CHAIN_ID][CONTRACT_STORAGE][0]
STORAGE_JSON = json.load(open(f"build/deployments/{CHAIN_ID}/{STORAGE_ADDRESS}.json"))
contract = w3.eth.contract(address=STORAGE_ADDRESS, abi=STORAGE_JSON['abi'])


def int_to_addr(num):
    return f"0x{num:064x}"


def get_next_addr(addr, element_bit, n_bit):
    n_bit = n_bit if (n_bit := n_bit + element_bit) <= MAX_BIT_IN_SLOT else False

    if n_bit is False:
        addr = int_to_addr(int(addr, 16) + 1)
        n_bit = element_bit
    return addr, n_bit


def get_element_value(hex_value, element_bit, current_bit):
    bit = f"{int(hex_value, 16):0256b}"
    bit = bit[-element_bit:] if current_bit == element_bit else bit[-current_bit:-(current_bit - element_bit)]

    return bit


print("---------------------")
print("FIXED SIZE STATE: uint8, uint16, uint24, uint32, uint64, uint128, uint256, bool, address")
FIXED_SIZE_SLOT = 0
STATE_BIT = 128
CURRENT_BIT = 0

arr_address = int_to_addr(FIXED_SIZE_SLOT)
slot_value: HexBytes = w3.eth.get_storage_at(STORAGE_ADDRESS, arr_address)
state_value = get_element_value(slot_value.hex(), STATE_BIT, CURRENT_BIT + STATE_BIT)
print("SLOT:", FIXED_SIZE_SLOT, " ADDR:", arr_address, "SLOT_VALUE:", slot_value.hex(), "STATE_VALUE:", hex(int(state_value, 2)), "VALUE:", int(state_value, 2))

print("---------------------")
print("DYNAMIC ARRAY STATE: ")
ARR_SLOT = 20
ELEMENT_BIT = 256

arr_address = int_to_addr(ARR_SLOT)
slot_value: HexBytes = w3.eth.get_storage_at(STORAGE_ADDRESS, arr_address)
arr_length = w3.toInt(slot_value)

element_list = []

# first element address:
element_addr = w3.keccak(hexstr=arr_address).hex()
next_bit = 0
slot_value = 0
for i in range(0, arr_length):
    element_addr, next_bit = get_next_addr(element_addr, ELEMENT_BIT, next_bit)
    slot_value: HexBytes = w3.eth.get_storage_at(STORAGE_ADDRESS, element_addr) if (next_bit == ELEMENT_BIT or not slot_value) else slot_value
    element_value = get_element_value(slot_value.hex(), ELEMENT_BIT, next_bit)
    element_list.append((element_addr, element_value))

print("slot:", ARR_SLOT, " ADDR:", arr_address, " LENGTH:", w3.toInt(arr_length))
for i in range(0, len(element_list)):
    print("  -- Element ", i, ":", "ADDR:", element_list[i][0], " VALUE:", int(element_list[i][1], 2))

print("---------------------")
print("MAPPING: ")
KEY = "abc"
MAPPING_SLOT = 22

contract.functions.add_mapping(KEY, 123).transact({"from": w3.eth.accounts[0]})
mapping_address = int_to_addr(MAPPING_SLOT)

key_hex = KEY.encode().hex()  # convert string ascii -> binary: 1 char = 8 bits -> hex: abc=0110 0001 0110 0010 0110 0011 = 0x616263
value_addr = w3.keccak(hexstr=(key_hex + mapping_address[2:])).hex()
value: HexBytes = w3.eth.get_storage_at(STORAGE_ADDRESS, value_addr)
print("SLOT:", MAPPING_SLOT, "ADDR:" + mapping_address, "VALUE_ADDR:", value_addr, "VALUE:", int(value.hex(), 16))

print("---------------------")
print("String: ")
STRING_SLOT = 23
STRING = "Examining the respective work that has been done, we believe that data storage in Ethereum is an under-researched topic"

contract.functions.set_string(STRING).transact({"from": w3.eth.accounts[0]})
string_address = int_to_addr(STRING_SLOT)
slot_value: HexBytes = w3.eth.get_storage_at(STORAGE_ADDRESS, string_address)

# if string <32 bit : last 8 bit is length - else: all slot is length
value_hex, length = (slot_value.hex()[2:][:length], length) if (length := int(slot_value.hex()[-2:], 16)) < MAX_HEX_IN_SLOT and int(slot_value.hex()[2:][:8], 16) != 0 else (None, int(slot_value.hex(), 16))

if not value_hex:
    value_hex = ""
    addr = w3.keccak(hexstr=string_address).hex()
    for i in range(0, math.ceil(length / MAX_HEX_IN_SLOT)):

        next_addr = int_to_addr(int(addr, 16) + i)
        value_hex += w3.eth.get_storage_at(STORAGE_ADDRESS, next_addr).hex()[2:]


value_string = bytes.fromhex(value_hex).decode()
print("STRING_ADDR:", string_address, "STRING_LENGTH:", int(slot_value.hex(),16), "HEX:", value_hex, "DECODE:", value_string)



