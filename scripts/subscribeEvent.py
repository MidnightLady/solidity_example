import json
from web3 import Web3
import time
Web3.toText(hexstr=0x470012B8751AF02C0154DCCBBEE4865DFACAD3373218419DB94FBDC4CAEBF3CA)
CHAIN_ID = "1337"
CONTRACT_NAME = "AirdropToken"
MAP = json.load(open('build/deployments/map.json'))
CONTRACT_ADDRESS = MAP[CHAIN_ID][CONTRACT_NAME][0]
CONTRACT_JSON = json.load(open(f"build/deployments/{CHAIN_ID}/{CONTRACT_ADDRESS}.json"))

w3 = Web3(Web3.HTTPProvider('http://127.0.0.1:7545'))

contract = w3.eth.contract(address=CONTRACT_ADDRESS, abi=CONTRACT_JSON['abi'])
event_transfer = contract.events.Transfer.createFilter(fromBlock="0x0")
event_approval = contract.events.Approval.createFilter(fromBlock="0x0")

print("Event listening.....")

def handle_event(event):
    print("Event: ",event)


while True:
    new_transfer = event_transfer.get_new_entries()
    new_approval = event_approval.get_new_entries()

    for event in new_transfer:
        handle_event(event)
    for event in new_approval:
        handle_event(event)
    time.sleep(2)
    #    print("Get Hash:", contract.functions.getHash().call())

