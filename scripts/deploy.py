from brownie import *


def main():
    # requires brownie account to have been created
    # if network.show_active() == 'development':

    # add these accounts to metamask by importing private key
    # accounts.add(private_key="0x3662a22892fc295c76adb33fc89ee7c8e1cdf769d7e059d28d0bed0d659eeaf9")

    # owner = accounts[0]
    # owner.transfer(accounts[-1], "10 ether")
    # SimpleStorage.deploy({'from': accounts[0]})
    # TransferDemo.deploy({'from': accounts[0]})
    # ReceiveEther.deploy({'from': accounts[0]})
    # TransferSendCall.deploy({'from': accounts[0]})
    # token = AirdropToken.deploy("Huy","Ga", {'from': accounts[0]})
    # TokenVault.deploy(token.address,{'from': accounts[0]})

    A.deploy({'from': accounts[0]})
    B.deploy({'from': accounts[0]})
    C.deploy({'from': accounts[0]})
    # a = A[-1]; b = B[-1]; c = C[-1]



    # s1 = SimpleStorage[-1]
    # MemoryVSStorage.deploy({'from': accounts[0]})
    # testEnum.deploy({'from': accounts[0]})
    # C.deploy({'from': accounts[0]})
    # Token.deploy("Test Token", "TST", 18, 1e21, {'from': accounts[0]})

# get transaction : tx = chain.get_transaction
# t = AirdropToken[-1]; v = TokenVault[-1]; a0 = accounts[0]; a1= accounts[1]
# t.approve(v.address, 1000000, {'from':a0})
# v.receiveToken(t.address, 8000000,{'from':a0})
