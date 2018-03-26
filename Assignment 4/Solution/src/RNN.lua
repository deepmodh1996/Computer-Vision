do
    local RNN = torch.class('RNN')

    function RNN:__init(inputDimension, hiddenDimension)
        self.numHidden = hiddenDimension
        self.numInput = inputDimension
        self.W = torch.rand(hiddenDimension, inputDimension + hiddenDimension) - 0.5 
        self.B = torch.rand(hiddenDimension) - 0.5
        self.gradW = torch.Tensor()
        self.gradB = torch.Tensor()
        self.H = torch.Tensor()
    end

    function RNN:forward(input)
        self.H = torch.Tensor()
        local localH = torch.zeros(self.numHidden)
        for i = 1, input:size(1) do
            localH = torch.tanh(torch.mv(self.W, torch.cat(localH, input[i])) + self.B) 
            self.H = self.H:cat(localH)
        end
        self.H:resize(input:size(1), self.numHidden)
        return self.H
    end

    function RNN:backward(input, gradOutput)
        dhnext = gradOutput
        dW = torch.Tensor(self.numHidden, self.numHidden + self.numInput):fill(0)
        db = torch.zeros(self.numHidden)
        numBackward = input:size(1) - truncateLength
        if 2 > numBackward then numBackward = 2 end
            t = input:size(1)
            dhraw = torch.cmul(torch.csub(torch.Tensor(self.numHidden):fill(1), torch.cmul(self.H[t], self.H[t])), dhnext)
            db = db + dhraw
            db = torch.clamp(db, -1*clampSize, clampSize)
            dW = dW + (dhraw:view(-1, 1) * torch.cat(self.H[t-1], input[t]):view(1, -1))
            dW = torch.clamp(dW, -1*clampSize, clampSize)
            dhnext = dW:sub(1, self.numHidden, 1, self.numHidden):t() * dhraw:view(-1, 1)
            dhnext = torch.clamp(dhnext, -1*clampSize, clampSize)

            toReturn = dW:sub(1, self.numHidden, self.numHidden + 1, self.numHidden + self.numInput):t() * dhraw:view(-1, 1)
            toReturn = torch.clamp(toReturn, -1*clampSize, clampSize)



        for t2 = input:size(1) - 1, numBackward, -1 do
            dhraw = torch.cmul(torch.csub(torch.Tensor(self.numHidden):fill(1), torch.cmul(self.H[t2], self.H[t2])), dhnext)
            db = db + dhraw
            db = torch.clamp(db, -1*clampSize, clampSize)
            dW = dW + (dhraw:view(-1, 1) * torch.cat(self.H[t2-1], input[t2]):view(1, -1))
            dW = torch.clamp(dW, -1*clampSize, clampSize)
            dhnext = dW:sub(1, self.numHidden, 1, self.numHidden):t() * dhraw:view(-1, 1)
            dhnext = torch.clamp(dhnext, -1*clampSize, clampSize)
        end

        self.W = self.W - learningRate * dW
        self.B = self.B - learningRate * db
        return toReturn:view(-1)
    end
end