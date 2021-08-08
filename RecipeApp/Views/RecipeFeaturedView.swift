//
//  RecipeFeaturedView.swift
//  RecipeApp
//
//  Created by Michael Shustov on 08.08.2021.
//

import SwiftUI

struct RecipeFeaturedView: View {
    
    @EnvironmentObject var model:RecipeModel
    
    @State var isDetailViewShow = false
    
    @State var tabSelectionIndex = 0
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0){
            
            Text("Featured recipes")
                .padding(.leading, 20)
                .padding(.top, 40)
                .font(Font.custom("Avenir Heavy", size: 28))
            
            GeometryReader { geo in
                
                TabView (selection: $tabSelectionIndex) {
                    
                    ForEach(0..<model.recipes.count) { index in
                        
                        if model.recipes[index].featured {
                            
                            Button(action: {
                                
                                self.isDetailViewShow = true
                                
                            }, label: {
                                
                                ZStack {
                                    
                                    Rectangle()
                                        .foregroundColor(.white)
                                    
                                    VStack{
                                        
                                        Image(model.recipes[index].image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .clipped()
                                        
                                        Text(model.recipes[index].name)
                                            .padding(5)
                                            .font(Font.custom("Avenir", size: 15))
                                    }
                                }
                            })
                            .tag(index)
                            .sheet(isPresented: $isDetailViewShow) {
                                RecipeDetailView(recipe: model.recipes[index])
                            }
                            .buttonStyle(PlainButtonStyle())
                            .frame(width: geo.size.width - 40, height: geo.size.height - 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .cornerRadius(20)
                            .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.8), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: -5, y: 5)
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            }
            
            VStack(alignment: .leading, spacing: 10){
                
                Text("Preparation time")
                    .font(Font.custom("Avenir Heavy", size: 16))
                
                Text(model.recipes[tabSelectionIndex].prepTime)
                    .font(Font.custom("Avenir", size: 15))
                
                Text("Highlights")
                    .font(Font.custom("Avenir Heavy", size: 16))
                
                RecipeHighlights(highlights: model.recipes[tabSelectionIndex].highlights)
            }
            .padding([.leading, .bottom], 20)
        }
        .onAppear(perform: {
            setFeaturedIndex()
        })
    }
    
    func setFeaturedIndex() {
        
        var index = model.recipes.firstIndex { (recipe) -> Bool
            in
            return recipe.featured
        }
        
        tabSelectionIndex = index ?? 0
    }
}

struct RecipeFeaturedView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeFeaturedView()
            .environmentObject(RecipeModel())
    }
}
