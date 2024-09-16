//
//  ResultView.swift
//  PaletteM
//
//  Created by 이종선 on 9/16/24.
//

import SwiftUI

struct ResultView: View {
    
    @Environment(\.modelContext) private var context
    @EnvironmentObject var vm: ColorExtractorViewModel
    @Binding var path: [NavigationDestination]
    @Binding var isShowSelectGallery: Bool
    
    
    var body: some View {
        
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [.lightBeige, .darkBeige]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                // 이미지가 선택되었고 처리 완료된 경우 보여줌
                // MARK: 선택 이미지로 변경
                if let image = vm.selectedImage, !vm.distinctColors.isEmpty  {
                     
                    FlipCard(image: image, colors: vm.distinctColors)
                
                } else if (vm.selectedImage != nil && vm.isProcessing) || (vm.selectedImage != nil && vm.distinctColors.isEmpty) {
                    // 처리 중일 때는 ProgressView 표시
                    if let selectedImage = vm.selectedImage{
                        RotatingCardView(image: selectedImage) // 계속 회전하는 카드 애니메이션
                    }
                   
                        
                    
                } else {
                    // 선택된 이미지가 없을 때 메시지 표시
                    Text("No image selected.")
                        .foregroundColor(.gray)
                }
            }
        }
        .onDisappear{
            vm.resetImage()
        }
        .navigationBarBackButtonHidden()
        .toolbar{
            
            ToolbarItem(placement: .topBarLeading) {
                Button{
                    path.removeAll()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("뒤로")
                    }
                    .fontWeight(.semibold)
                }
                .disabled(vm.isProcessing)
            }
            
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    save()
                    isShowSelectGallery = false
                } label: {
                    Text("저장")
                        .fontWeight(.semibold)
                }
                .disabled(vm.isProcessing)
                
            }
        }
        .tint(.softCharcoal)
    }
    
    func save(){
        if let selectedImage = vm.selectedImage {
            guard let imageData = selectedImage.jpegData(compressionQuality: 1.0) else {
                return
            }
            let card = ImageData(imageData: imageData, colorInfos: vm.distinctColors)
            context.insert(card)
            do {
                try context.save()
                print("Image saved successfully")
            } catch {
                print("Failed to save image: \(error)")
            }
        }
    }
}
