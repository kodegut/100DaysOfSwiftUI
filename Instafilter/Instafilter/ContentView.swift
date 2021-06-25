//
//  ContentView.swift
//  Instafilter
//
//  Created by Tim Musil on 19.06.21.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var showingFilterSheet = false
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    @State private var currentFilterText = "Sepia Tone"
    
    @State private var showingAlert = false
    
    
    
    
    var body: some View {
        
        let intensity = Binding<Double>(
            get: {
                self.filterIntensity
            },
            set: {
                self.filterIntensity = $0
                self.applyProcessing()
            }
        )
        
        return NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.secondary)
                    
                    if image != nil {
                        image?
                            .resizable()
                            .scaledToFit()
                    } else {
                        Text("Tap to select a picture")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                .overlay(
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("kodegut")
                                .frame(width: 100)
                                .foregroundColor(.white)
                                .background(Color.black.opacity(0.7))
                                .clipShape(Capsule())
                                .padding()
                                .padding(.trailing, 10)
                        }
                    })
                .onTapGesture {
                    self.showingImagePicker = true
                }
                
                HStack {
                    Text("Intensity")
                    Slider(value: intensity)
                }.padding(.vertical)
                
                HStack {
                    Button(currentFilterText) {
                        self.showingFilterSheet = true
                    }
                    
                    Spacer()
                    
                    Button("Save") {
                        guard let processedImage = self.processedImage else {
                            showingAlert = true
                            return
                            
                        }
                        
                        let imageSaver = ImageSaver()
                        
                        imageSaver.successHandler = {
                            print("Success!")
                        }
                        
                        imageSaver.errorHandler = {
                            print("Oops: \($0.localizedDescription)")
                        }
                        
                        imageSaver.writeToPhotoAlbum(image: processedImage)
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationBarTitle("Instafilter")
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
            .actionSheet(isPresented: $showingFilterSheet) {
                ActionSheet(title: Text("Choose Filter"), buttons: [
                    .default(Text("Crystallize")) { self.setFilter(CIFilter.crystallize())
                        self.currentFilterText = "Crystallize"
                    },
                    .default(Text("Edges")) { self.setFilter(CIFilter.edges())
                        self.currentFilterText = "Edges"
                    },
                    .default(Text("Gaussian Blur")) { self.setFilter(CIFilter.gaussianBlur())
                        self.currentFilterText = "Gaussian Blur"
                    },
                    .default(Text("Pixellate")) { self.setFilter(CIFilter.pixellate())
                        self.currentFilterText = "Pixellate"
                    },
                    .default(Text("Sepia Tone")) { self.setFilter(CIFilter.sepiaTone())
                        self.currentFilterText = "Sepia Tone"
                    },
                    .default(Text("Unsharp Mask")) { self.setFilter(CIFilter.unsharpMask())
                        self.currentFilterText = "Unsharp Mask" 
                    },
                    .default(Text("Vignette")) { self.setFilter(CIFilter.vignette())
                        self.currentFilterText = "Vignette"
                    },
                    .cancel()
                ])
            }
            .alert(isPresented: $showingAlert, content: {
                Alert(
                    title: Text("No Picture"),
                    message: Text("It seems there is no picture yet to save"),
                    dismissButton: .default(Text("Ok"))
                )
            })
            
        }
        
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey) }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
