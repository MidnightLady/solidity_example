import json
from web3 import Web3
import time

w3 = Web3(Web3.HTTPProvider('http://127.0.0.1:8545'))

CHAIN_ID = "dev"
CONTRACT_TOKEN = "AirdropToken"
MAP = json.load(open('build/deployments/map.json'))
CONTRACT_ADDRESS = MAP[CHAIN_ID][CONTRACT_TOKEN][0]
CONTRACT_JSON = json.load(open(f"build/deployments/{CHAIN_ID}/{CONTRACT_ADDRESS}.json"))


contract_token = w3.eth.contract(address=CONTRACT_ADDRESS, abi=CONTRACT_JSON['abi'])
event_transfer = contract_token.events.Transfer.createFilter(fromBlock="0x0")
event_approval = contract_token.events.Approval.createFilter(fromBlock="0x0")


CONTRACT_VAULT = json.load(open(f"build/deployments/{CHAIN_ID}/{MAP[CHAIN_ID]['TokenVault'][0]}.json"))
vault = w3.eth.contract(address=MAP[CHAIN_ID]['TokenVault'][0], abi=CONTRACT_VAULT['abi'])
event_receive = vault.events.Received.createFilter(fromBlock="0x0")

print("Event listening.....")


def handle_event(event):
    print(event['event']," : ", event)


while True:
    new_transfer = event_transfer.get_new_entries()
    new_approval = event_approval.get_new_entries()
    new_receive = event_receive.get_new_entries()

    for event in new_transfer:
        handle_event(event)
    for event in new_approval:
        handle_event(event)
    for event in new_receive:
        handle_event(event)
    time.sleep(2)
