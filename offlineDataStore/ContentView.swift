//
//  ContentView.swift
//  offlineDataStore
//
//  Created by Prajjwal Gupta on 10/12/24.
//

import SwiftUI
import SwiftData
import PhotosUI
import AVKit

struct ContentView: View {
    @Environment(\.modelContext) var moc
    @Query(animation: .smooth) var medias: [VideosImages]
    @State private var showAdd: Bool = false
    var column = Array(repeating: GridItem(.flexible(), spacing: 2), count: 2)
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: column){
                    ForEach(medias, id: \.id) { media in
                        VStack(alignment: .leading) {
                            if let videoURL = media.videoURL {
                                VideoPlayer(player: AVPlayer(url: videoURL))
                                    .aspectRatio(contentMode: .fit)
                            }
                            if let imgData = media.imgData {
                                Image(uiImage: UIImage(data: imgData)!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            HStack {
                                Text(media.title)
                                    .bold()
                                    .underline()
                                Spacer()
                                Button(action: {
                                    media.likes.toggle()
                                }, label: {
                                    Image(systemName: media.likes ? "heart.fill" : "heart")
                                        .foregroundStyle(media.likes ? .red : .gray)
                                })
                            }
                            Text(media.fecha, style: .date)
                                .font(.caption2)
                                .foregroundStyle(.gray)
                            Text(media.details)
                        }.padding()
                            .background()
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 6)
                    }.padding()
                }
            }.navigationTitle("ContentPro")
                .toolbar {
                    Button(action: {
                        self.showAdd.toggle()
                    }, label : {
                        Image(systemName: "video.badge.plus")
                    })
                }
                .sheet(isPresented: self.$showAdd, content: {
                    AddMediaView()
                })
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: VideosImages.self)
}

struct AddMediaView: View {
    @Environment(\.modelContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var videoURL: URL?
    @State private var imgData: Data?
    
    @State private var title: String = ""
    @State private var details: String = ""
    
    @State private var showPicker: Bool
    
    init(showPicker: Bool = false) {
          self._showPicker = State(initialValue: showPicker)
      }
    var body: some View {
        NavigationStack {
            Form {
                HStack {
                    Spacer()
                    if let videoURL = videoURL {
                        VideoPlayer(player: AVPlayer(url: videoURL))
                            .aspectRatio(contentMode: .fit)
                            .onTapGesture {
                                withAnimation(.smooth) {
                                    self.showPicker.toggle()
                                }
                            }
                    }
                   else if let imgData = imgData {
                        Image(uiImage: UIImage(data: imgData)!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .onTapGesture {
                                withAnimation(.smooth) {
                                    self.showPicker.toggle()
                                }
                            }
                    } else {
                        Button(action: {
                            withAnimation(.smooth) {
                                self.showPicker.toggle()
                            }
                        }, label: {
                            Image(systemName: "video")
                                .font(.system(size: 50))
                        })
                    }
                    Spacer()
                    
                }
                TextField("Title...", text: self.$title)
                TextField("Details...", text: self.$details)
                Text("Add Content")
                    .font(.title2.bold())
                    .padding(6)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .onTapGesture {
                        withAnimation(.smooth) {
                            let new = VideosImages(videoURL: self.videoURL,imgData: self.imgData ,title: self.title, details: self.details, fecha: Date(), likes: Bool())
                            self.moc.insert(new)
                            dismiss()
                        }
                    }
                
            }.navigationTitle("Add Content")
                .toolbar{
                    ToolbarItem(placement: .cancellationAction) {
                        Button(action: {
                            withAnimation(.smooth) {
                                dismiss()
                            }
                        }, label: {
                            Text("Cancel")
                        })
                    }
                }.sheet(isPresented: self.$showPicker) {
                    VideoPicker(videoURL: self.$videoURL, image: self.$imgData)
                }
        }
    }
}
#Preview {
    AddMediaView()
}
