require 'nn'
require 'cunn'
require 'cudnn'

-- Same as scratch training directly with pruning.

print '==> building model'

local model = nn.Sequential()

-- Conv11 & Conv12 & Pool1
model:add(cudnn.SpatialConvolution(3, 64, 3, 3, 1, 1, 1, 1)) --1
model:add(nn.BatchNormalization(64))
model:add(nn.PReLU(true))
model:add(cudnn.SpatialConvolution(64, 128, 3, 3, 1, 1, 1, 1)) --3
model:add(nn.BatchNormalization(128))
model:add(nn.PReLU(true))
model:add(cudnn.SpatialMaxPooling(2, 2, 2, 2))

-- Conv21 & Conv22 & Pool2
model:add(cudnn.SpatialConvolution(128, 64, 3, 3, 1, 1, 1, 1)) -- 6
model:add(nn.BatchNormalization(64))
model:add(nn.PReLU(true))
model:add(cudnn.SpatialConvolution(64, 128, 3, 3, 1, 1, 1, 1)) -- 8
model:add(nn.BatchNormalization(128))
model:add(nn.PReLU(true))
model:add(cudnn.SpatialMaxPooling(2, 2, 2, 2))

-- Conv31 & Conv32 & Pool 4
model:add(cudnn.SpatialConvolution(128, 64, 3, 3, 1, 1, 1, 1)) -- 11
model:add(nn.BatchNormalization(64))
model:add(nn.PReLU(true))
model:add(cudnn.SpatialConvolution(64, 128, 3, 3, 1, 1, 1, 1)) -- 13
model:add(nn.BatchNormalization(128))
model:add(nn.PReLU(true))
model:add(cudnn.SpatialMaxPooling(2, 2, 2, 2))

-- Conv41 & Conv42 & Pool 4
model:add(cudnn.SpatialConvolution(128, 128, 3, 3, 1, 1, 1, 1)) -- 16
model:add(nn.BatchNormalization(128))
model:add(nn.PReLU(true))
model:add(cudnn.SpatialConvolution(128, 256, 3, 3, 1, 1, 1, 1)) -- 18
model:add(nn.BatchNormalization(256))
model:add(nn.PReLU(true))
model:add(cudnn.SpatialMaxPooling(2, 2, 2, 2))

-- Conv51 & Conv52 & Pool5
model:add(cudnn.SpatialConvolution(256, 128, 3, 3, 1, 1, 1, 1)) -- 21
model:add(nn.BatchNormalization(128))
model:add(nn.PReLU(true))
model:add(cudnn.SpatialConvolution(128, 256, 3, 3, 1, 1, 1, 1)) -- 23
model:add(nn.BatchNormalization(256)) -- not sure about this....
model:add(cudnn.SpatialAveragePooling(2, 2, 2, 2, 1, 1))

-- Dropout & Fc6 & Fc7 & LogSoftMax
model:add(nn.Reshape(256*5*5,true))
model:add(nn.Dropout(0.4))
model:add(nn.Linear(256*5*5, 512))
model:add(nn.Linear(512, #dataset.classes))
model:add(nn.LogSoftMax())

return model