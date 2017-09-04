/*
* Copyright (c) 2017 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import CoreData

class DetailViewController: UIViewController, UITextViewDelegate {
  
  @IBOutlet weak var detailTextView: UITextView!
  
  var note: Note?
  
  func configureView() {
    
    guard let note = note else {
      return
    }
    
    detailTextView?.text = note.noteText
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }
  
}

// MARK: - UITextFieldDelegate
extension DetailViewController: UITextFieldDelegate {
  
  func textViewDidEndEditing( _ textView: UITextView) {
    
    guard let note = note else {
      return
    }
    
    note.noteText = detailTextView.text
    
    do {
      try note.managedObjectContext?.save()
    } catch {
      print("nothing saved.")
    }
  }
  
}

