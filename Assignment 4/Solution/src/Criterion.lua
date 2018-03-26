do
    local Criterion = torch.class('Criterion') -- Cross Entropy Loss

    function Criterion:__init()
    end

    function Criterion:forward(pred, target)
        ans = -1*torch.log(torch.cmul(pred, target):sum())
        return ans
    end

    function Criterion:backward(pred, target)
        return pred:csub(target)
    end
end