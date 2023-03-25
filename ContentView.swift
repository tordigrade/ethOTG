import SwiftUI


struct ContentView: View {
    @State private var ethPrice = "..."
    @State private var gasPrice = "..."
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image("ethLogoIconTrans50")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 50)
                Text(ethPrice)
                    .font(.title3)
                    .fontDesign(.monospaced)
                Spacer()
                Image(systemName: "fuelpump.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                Text(gasPrice)
                    .font(.title3)
                    .fontDesign(.monospaced)
                Spacer()
            }
            Button(action: {
                getEthPrice()
                getGasPrice()
            }) {
                Circle()
                    .stroke(lineWidth: 2)
                    .frame(width: 50)
                    .overlay(Image(systemName: "arrow.clockwise")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15))
                
            }
            .padding()
        }
        .onAppear {
            getEthPrice()
            getGasPrice()
        }
    }
    
    
    func getEthPrice() {
        guard let url = URL(string: "https://api.etherscan.io/api?module=stats&action=ethprice&apikey=YOUR_ETHERSCAN_API_KEY") else {
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                return
            }
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(EthPriceResult.self, from: data)
                DispatchQueue.main.async {
                    self.ethPrice = result.result.ethusd
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func getGasPrice() {
        guard let url = URL(string: "https://api.etherscan.io/api?module=gastracker&action=gasoracle&apikey=YOUR_ETHERSCAN_API_KEY") else {
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                return
            }
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(GasPriceResult.self, from: data)
                DispatchQueue.main.async {
                    self.gasPrice = result.result.ProposeGasPrice
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}

struct EthPriceResult: Codable {
    let result: EthPrice
}

struct EthPrice: Codable {
    let ethusd: String
}

struct GasPriceResult: Codable {
    let result: GasPrice
}

struct GasPrice: Codable {
    let ProposeGasPrice: String
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
