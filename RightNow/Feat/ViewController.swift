//
//  ViewController.swift
//  RightNow
//
//  Created by 정성윤 on 2024/06/17.
//

import UIKit
import PDFKit

class ViewController: UIViewController {
    var pdfView = PDFView()
    var fileURL: URL? // 다운로드한 파일의 URL을 저장하기 위한 변수
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow
        // Usage
        let copyrightInfo: [String: Any] = [
            "intake_number": "123456",
            "intake_date": "2024-06-07",
            "works": ["title": "Sample Title", "category": "Sample Category"],
            "self": true,
            "privacy": ["name": "John Doe", "country": "USA", "rrn": "123456-7890123", "address": "1234 Main St", "phone": "555-1234", "e-mail": "johndoe@example.com", "identify": "저작자 본인", "sign_path": "사인.png"]
        ]
        
        let today: [String: Any] = [
            "year": "2024",
            "month": "06",
            "day": "07"
        ]
        
//        JsonTodocx.generateApplicationForm(copyrightInfo: copyrightInfo, today: today) { result in
//            switch result {
//            case .success(let fileURL):
//                print("Document generated successfully: \(fileURL)")
//                DispatchQueue.main.async {
//                    self.showPDF(file: fileURL)
//                }
//            case .failure(let error):
//                print("Failed to generate document: \(error.localizedDescription)")
//            }
//        }
    }
    
    func showPDF(file: URL) {
        // PDFView 설정
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pdfView.frame = self.view.bounds
        pdfView.displayMode = .singlePageContinuous
        pdfView.autoScales = true
        
        // PDF 파일 로드
        if let document = PDFDocument(url: file) {
            pdfView.document = document
            self.view.addSubview(pdfView)
        } else {
            print("Failed to load PDF document.")
        }
    }
}
