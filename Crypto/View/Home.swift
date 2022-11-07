//
//  Home.swift
//  Crypto
//
//  Created by Waris Ruzi on 2022/11/07.
//

import SwiftUI
import SDWebImageSwiftUI

struct Home: View {
    @State var currentCoin: String = "BTC"
    @Namespace var animation
    @StateObject var appModel: AppViewModel = AppViewModel()
    var body: some View {
        VStack{
            if let coins = appModel.coins,let coin = appModel.currentCoin {
                //MARK: Sample UI
                HStack(spacing: 15){

                    VStack(alignment: .trailing, spacing: 5){
                        Text(coin.name)
                            .font(.custom(Uyghur, size: 18))
                        Text(coin.symbol.uppercased())
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                    }
                    
                    AnimatedImage(url: URL(string: coin.image))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                CustomControl(coins: coins)
                
                VStack(alignment: .trailing, spacing: 8){
                    Text(coin.current_price.convertToCurrency())
                        .font(.largeTitle.bold())
                    //MARK: Profit/Loss
                    Text("\(coin.price_change > 0 ? "+" : "")\(String(format:  "%.2f", coin.price_change))")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(coin.price_change < 0 ? .white : .black)
                        .padding(.horizontal,10)
                        .padding(.vertical,5)
                        .background{
                            Capsule()
                                .fill(coin.price_change < 0 ? .red :Color("LightGreen"))
                        }
                    
                }
                .frame(maxWidth: .infinity, alignment: .trailing)

                GraphView(coin: coin)
                
                Controls()
            }
            else {
                ProgressView()
                    .tint(Color("LightGreen"))
            }


        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    //MARK: Line Graph
    @ViewBuilder
    func GraphView(coin: CryptoModel)->some View{
        GeometryReader{_ in
            LineGraph(data: coin.last_7days_price.price,profit: coin.price_change > 0)
        }
        .padding(.vertical,30)
        .padding(.bottom,20)
    }
    
    //MARK: Custom Segmented Control
    @ViewBuilder
    func CustomControl(coins: [CryptoModel])->some View{
        //MARK: Sample Data
        ScrollView(.horizontal , showsIndicators: false){
            HStack(spacing: 15){
                ForEach(coins) {coin in
                    Text(coin.symbol.uppercased())
                        .foregroundColor(currentCoin == coin.symbol.uppercased() ? .white : .gray)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .contentShape(Rectangle())
                        .background{
                            if currentCoin == coin.symbol.uppercased(){
                                Rectangle()
                                    .fill(Color("Tab"))
                                    .matchedGeometryEffect(id: "SEGMENTEDTAB", in: animation)
                            }
                        }
                        .onTapGesture {
                            appModel.currentCoin = coin
                            withAnimation {
                                currentCoin = coin.symbol.uppercased()
                            }
                        }
                }
            }
        }
        .background{
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        }
        .padding(.vertical)
    }
    
    //MARK: Controls
    @ViewBuilder
    func Controls()->some View{
        HStack(spacing: 20){
            Button {
                
            } label: {
                Text("ساتماق")
                    .font(.custom(Uyghur, size: 20))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background{
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.white)
                    }
            }
            
            Button {
                
            } label: {
                Text("ئالماق")
                    .font(.custom(Uyghur, size: 20))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background{
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color("LightGreen"))
                    }
            }
            

        }
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//MARK: Converting Double To Currency
extension Double {
    func convertToCurrency()->String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return formatter.string(from: .init(value: self)) ?? ""
    }
}
