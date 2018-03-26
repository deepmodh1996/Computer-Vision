-- require('RNN.lua')

do
    local Model = torch.class('Model')

    function Model:__init()
        self.nLayers = 0
        self.Layers = {}
        self.Boutput = torch.rand(2) - 0.5
        self.Woutput = torch.Tensor()
        self.input = {}
        self.output = torch.Tensor()
        self.finalIndexInOneHotEncoding = 0
        self.mapTable = {}
        self.H = 0
        self.V = 153
        self.D = 2948
    end

    function Model:add(inputDimension, hiddenDimension)
        table.insert(self.Layers, RNN(inputDimension, hiddenDimension))
        self.Woutput = torch.rand(2, hiddenDimension) - 0.5 -- treating added layer as last layer
        self.nLayers = self.nLayers + 1
    end

    function Model:forward(input)
        self.input = {}
        n = input:size(1)
        for i = 1, self.nLayers do
            self.input[i] = input
            output = self.Layers[i]:forward(input)
            input = output
        end
        self.output = output
        predTemp = torch.mv(self.Woutput, output[n]) + self.Boutput
        pred = torch.exp(predTemp)
        pred = pred/pred:sum()
        return pred
    end

    function Model:backward(input, gradOutput)
        dy = gradOutput
        dWoutput = dy:view(-1, 1) * self.output[input:size(1)]:view(1, -1)
        dboutput = dy
        dhnext = self.Woutput:t() * dy
        for i = self.nLayers, 1, -1 do
            dhnext = self.Layers[i]:backward(self.input[i], dhnext)
        end
        self.Woutput = self.Woutput - learningRate * dWoutput
        self.Boutput = self.Boutput - learningRate * dboutput
    end

    function Model:setFinalIndexInOneHotEncoding(k)
        self.finalIndexInOneHotEncoding = k
    end

    function Model:setMapTable(mapTable)
        self.mapTable = mapTable
    end

    function Model:getFinalIndexInOneHotEncoding()
        return self.finalIndexInOneHotEncoding
    end

    function Model:getMapTable()
        return self.mapTable
    end
end