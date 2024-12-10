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
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
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
                        .background(.gray)
                        .shadow(radius: 6)
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
                    //Addmediaview
                })
        }
    }
}

#Preview {
    ContentView()
}
