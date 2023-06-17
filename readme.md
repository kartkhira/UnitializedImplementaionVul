# Unitialized Implementation Vulnerability

### Attack Steps

1. Attack Contract calls initialize method of jettyFuel Implementation contract. This will work as Jetty Fuel was initialized earlier in the context of proxy.
2. Attacker calls UpgradeToCall method from attack contract with data encoding "destroy()" method. 
3. selfdestruct deletes implementation's byte code as it's calling "destroy()" via a delegate call.
4. Proxy is rendered useless as it can't even upgrade implementation logic now.

### Please note that selfdestruct is not supported by foundry causing verfication issues. 
### Attack steps can be validated by analyzing stack traces during testing.

###
1. Setup
```
gh repo clone kartkhira/UnitializedImplementaionVul
```

2. Testing
```
forge test -vvvv
```

