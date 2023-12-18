//
//  SplashscreenView.swift
//  ArcadeGameTemplate
//
//  Created by Jakub Mantelli on 13/12/23.



import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false

    var body: some View {
        if isActive {
          ContentView()
        } else {
        
        

     
               
                
                VStack {
                    
                Image("Reaper's Hunt - Slpash Art")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                     
                       
    
                    
                      

                   
                    
                    
                }
                    
                    
                    .onAppear {
                    
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                         
                                
                                self.isActive = true
                            
                            }
                        }
                    }
                  
                   
                        
    
                  
            }
        }
        
        
                            



#Preview {
    SplashScreenView()
}
