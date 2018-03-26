require('./src/RNN.lua')
require('./src/Criterion.lua')
require('./src/Model.lua')

print('Starting testModel.lua ...')

cmd = torch.CmdLine()
cmd:option('-modelName', 'BestModel', 'Name of Folder to save model')
cmd:option('-data', './data/test_data.txt', 'Path to test data')


opt = cmd:parse(arg or {})
modelName = opt.modelName
testDataPath = opt.data

fileName = ''
for f in paths.files('' .. modelName .. '') do
   if f ~= '.' and f ~= '..' then 
   	fileName = f
   	break
   end
end

obj = torch.load('' .. modelName .. '/' .. fileName, 'ascii')

myModel = obj.model
mapTable = myModel:getMapTable()
k = myModel:getFinalIndexInOneHotEncoding() or 150

oneHotMap = torch.zeros(153, 153)
for i = 1, 153 do
    oneHotMap[i][i] = 1
end

testData = {}

local f3 = io.open(testDataPath)
while 1 do
    local l = f3:read()
    if not l then break end
    x = l:split(" ")
    y = torch.Tensor(x)
    z = torch.Tensor()
    for j = 1, y:size(1) do
        if mapTable[y[j]] == nil then
            mapTable[y[j]] = oneHotMap[k]
            k = k + 1
            if k > 154 then
                print('error : more than 153 !!!!!!!')
                os.exit()
            end
        end
        z = z:cat(mapTable[y[j]])
    end
    z:resize(y:size(1), 153)
    table.insert(testData, z)
end




f4 = io.open('testResult.txt', 'w')
f4:write('id,label')
f4:write('\n')

testPrediction = torch.Tensor(#testData):fill(0)

for i = 1, #testData do
    pred = myModel:forward(testData[i])
    pq, index = torch.max(pred, 1)
    f4:write(i-1)
    f4:write(',')
    f4:write(index[1]-1)
    f4:write('\n')
    testPrediction[i] = index[1] - 1
end

f4:close()
torch.save('testPrediction.bin', testPrediction, 'ascii')