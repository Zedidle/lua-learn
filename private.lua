local private_metatable = {
    __index = function(o, key)

        
    end
}

local function newAccount(initialBalance)
    local self = {balance = initialBalance}
    local withdraw = function(v)
        self.balance = self.balance - v
    end

    local deposit = function(v)
        self.balance = self.balance + v
    end

    local getBalance = function ()
        return self.balance 
    end

    return {
        withdraw = withdraw,
        deposit = deposit,
        getBalance = getBalance
    }
end


local accl = newAccount(100.00)
accl.withdraw(40.00)
print(accl.getBalance())
print(accl:getBalance())

local function newAccount2(initialBalance)
    local self = {
        balance = initialBalance,
        LIM = 10000.00,
    }

    local extra = function()
        if self.balance > self.LIM then
            return self.balance * 0.10            
        else
            return 0
        end
    end

    local getBalance = function()
        return self.balance + self.extra()
    end
end

-- local accl2 = newAccount2(200)
-- accl2.extra()
-- print(accl2:getBalance())
