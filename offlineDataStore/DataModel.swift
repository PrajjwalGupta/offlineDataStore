import Foundation
import SwiftData
import SwiftUI
import AVKit

@Model
final class VideosImages {
    @Attribute(.externalStorage) var videoURL: URL?
    @Attribute(.externalStorage) var imgData: Data?
    var title: String
    var details: String
    var fecha: Date
    var likes: Bool
    
    init(videoURL: URL? = nil, imgData: Data? = nil, title: String, details: String, fecha: Date, likes: Bool) {
        self.videoURL = videoURL
        self.imgData = imgData
        self.title = title
        self.details = details
        self.fecha = fecha
        self.likes = likes
    }
}

struct VideoPicker: UIViewControllerRepresentable {
    @Binding var videoURL: URL?
    @Binding var image: Data?
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.mediaTypes = ["public.movie", "public.image"]
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Update if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: VideoPicker
        
        init(parent: VideoPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let url = info[.mediaURL] as? URL {
                compressVideo(inputURL: url) { compressedURL in
                    DispatchQueue.main.async {
                        self.parent.videoURL = compressedURL
                        picker.dismiss(animated: true)
                    }
                }
            } else if let image = info[.originalImage] as? UIImage {
                DispatchQueue.main.async {
                    self.parent.image = image.jpegData(compressionQuality: 0.5)
                    picker.dismiss(animated: true)
                }
            } else {
                picker.dismiss(animated: true)
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
        
        private func compressVideo(inputURL: URL, completion: @escaping (URL?) -> Void) {
            let outputURL = inputURL.deletingLastPathComponent().appendingPathComponent("compressed.mp4")
            let asset = AVAsset(url: inputURL)
            
            guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality) else {
                completion(nil)
                return
            }
            
            exportSession.outputURL = outputURL
            exportSession.outputFileType = .mp4
            exportSession.exportAsynchronously {
                switch exportSession.status {
                case .completed:
                    completion(exportSession.outputURL)
                case .failed, .cancelled:
                    print("Video compression failed: \(String(describing: exportSession.error))")
                    completion(nil)
                default:
                    completion(nil)
                }
            }
        }
    }

    
  
}
