from brownie import *

# accounts.add(private_key="")
#

def main():
    a0 = accounts[0]; a1 = accounts[1]; a2 = accounts[2]
    # requires brownie account to have been created
    # if network.show_active() == 'development':
    #

    # owner = accounts[0]
    # owner.transfer(accounts[-1], "10 ether")

    # FundWallet.deploy({'from': accounts[0]})
    # SimpleStorage.deploy({'from': accounts[0]})
    # TransferDemo.deploy({'from': accounts[0]})
    # ReceiveEther.deploy({'from': accounts[0]})
    # TransferSendCall.deploy({'from': accounts[0]})

    ### Storage state:
    StorageState.deploy({'from': accounts[0]})
    s = StorageState[-1]

    ### airdrop token
    # token = AirdropToken.deploy("Huy", "Ga", {'from': accounts[0]})
    # TokenVault.deploy(token.address, {'from': accounts[0]})
    # t = AirdropToken[-1]; v = TokenVault[-1]
    # t.approve(v.address, 1000000, {'from':a0})
    # v.receiveToken(t.address, 8000000,{'from':a0})

    ### delegate call
    # A.deploy({'from': accounts[0]})
    # B.deploy({'from': accounts[0]})
    # C.deploy({'from': accounts[0]})
    # a = A[-1]; b = B[-1]; c = C[-1]
    #
    #
    # s1 = SimpleStorage[-1]
    # MemoryVSStorage.deploy({'from': accounts[0]})
    # testEnum.deploy({'from': accounts[0]})
    # C.deploy({'from': accounts[0]})
    # Token.deploy("Test Token", "TST", 18, 1e21, {'from': accounts[0]})
    #
    # get transaction : tx = chain.get_transaction
