#!/bin/bash

# 创建符号链接，使 Foundation 头文件在模块根级别暴露

cd "$(dirname "$0")/iOS/DoKit/Classes"

# 创建 PublicHeaders 目录
mkdir -p Core/PublicHeaders

# 创建符号链接
cd Core/PublicHeaders

ln -sf ../../Foundation/DKQRCodeScanLogic.h .
ln -sf ../../Foundation/DKQRCodeScanView.h .
ln -sf ../../Foundation/DKQRCodeScanViewController.h .
ln -sf ../../Foundation/DKMultiControlProtocol.h .
ln -sf ../../Foundation/DKMultiControlStreamManager.h .
ln -sf ../../Foundation/DKWebSocketSession.h .
ln -sf ../../Foundation/DTO/DKCommonDTOModel.h .
ln -sf ../../Foundation/DTO/DKActionDTOModel.h .
ln -sf ../../Foundation/DTO/DKDataRequestDTOModel.h .
ln -sf ../../Foundation/DTO/DKDataResponseDTOModel.h .
ln -sf ../../Foundation/DTO/DKLoginDataDTOModel.h .
ln -sf ../../Foundation/NSURLSessionConfiguration+DoKit.h .

echo "Symbolic links created:"
ls -la

