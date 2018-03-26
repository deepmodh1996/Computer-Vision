require('./src/RNN.lua')
require('./src/Criterion.lua')
require('./src/Model.lua')

print('Starting trainModel.lua ...')

cmd = torch.CmdLine()
cmd:option('-modelName', 'BestModel', 'Name of Folder to save model')
cmd:option('-data', './data/train_data.txt', 'Path to train data')
cmd:option('-target', './data/train_labels.txt', 'Path to train labels')

opt = cmd:parse(arg or {})
dataPath = opt.data
labelPath = opt.target
modelName = opt.modelName


learningRate = 0.01
truncateLength = 20
numEpoch = 40
clampSize = 2

mapTable = {}
trainData = {}
trainLabel = {}

oneHotMap = torch.zeros(153, 153)
for i = 1, 153 do
    oneHotMap[i][i] = 1
end

k = 1

local f = io.open(dataPath)
while 1 do
    local l = f:read()
    if not l then break end
    x = l:split(" ")
    y = torch.Tensor(x)
    z = torch.Tensor()
    for j = 1, y:size(1) do
        if mapTable[y[j]] == nil then
            mapTable[y[j]] = oneHotMap[k]
            k = k + 1
        end
        z = z:cat(mapTable[y[j]])
    end
    z:resize(y:size(1), 153)
    table.insert(trainData, z)
end

local f2 = io.open(labelPath)
zeroTarget = torch.Tensor({1, 0})
oneTarget = torch.Tensor({0, 1})
while 1 do
    local l = f2:read()
    if not l then break end
    x = l:split(" ")
    y = torch.Tensor(x)
    if y[1] == 0 then
        table.insert(trainLabel, zeroTarget)
    else
        table.insert(trainLabel, oneTarget)
    end
end


myModel = Model()
myModel:add(153, 64)

cel = Criterion()

for j = 1, numEpoch do
    totalErr = 0
    for i = 1, #trainData do
        pred = myModel:forward(trainData[i])
        err = cel:forward(pred, trainLabel[i])
        gradOut = cel:backward(pred, trainLabel[i])
        nothing = myModel:backward(trainData[i], gradOut)
        totalErr = totalErr + err
    end
    -- if j%100 == 0 then
    --     print(j .. ', ' .. totalErr)
    -- end
end

paths.mkdir('' .. modelName .. '')

obj = {}
myModel:setFinalIndexInOneHotEncoding(k)
myModel:setMapTable(mapTable)
obj['model'] = myModel
torch.save('./' .. modelName .. '/BestModel.dat', obj, 'ascii')

