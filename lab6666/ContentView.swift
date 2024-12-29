import SwiftUI

// MARK: - Protocol for Delegate Pattern
protocol FontPickerDelegate {
    func didPickFont(fontName: String)
}

protocol ColorPickerDelegate {
    func didPickColor(_ color: Color, colorName: String)
}

protocol SizePickerDelegate {
    func didPickSize(sizeName: String)
}

// MARK: - Main View
struct ContentView: View, FontPickerDelegate, ColorPickerDelegate, SizePickerDelegate {
    @State private var selectedFont: String = "Helvetica"
    @State private var selectedSize: String = "24"
    @State private var sampleText: String = "CSE 20"
    @State private var selectedColor: Color = .blue
    @State private var selectedColorName: String = "Blue"
    
    
    @State private var showFontPicker = false
    @State private var showColorPicker = false
    @State private var showSizePicker = false

    var body: some View {
        NavigationStack {
            VStack {
               
                Text(sampleText)
                    .font(.custom(selectedFont, size: CGFloat(Int(selectedSize) ?? 24)))
                    .foregroundColor(selectedColor)
                    .padding()

                TextField("Enter Sample Text", text: $sampleText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    showFontPicker = true
                }) {
                    Text("Pick a Font Style")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showFontPicker) {
                    FontPickerView(delegate: self)
                }
                
                Button(action: {
                    showSizePicker = true
                }) {
                    Text("Pick Font Size")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showSizePicker) {
                    SizePickerView(delegate: self)
                }
                
                // Button to navigate to Color Picker View
                Button(action: {
                    showColorPicker = true
                }) {
                    Text("Pick a Color")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showColorPicker) {
                    ColorPickerView(delegate: self)
                }

                // Display selected font name
                Text("Selected Font: \(selectedFont)")
                    .font(.headline)
                    .padding()
                Text("Selected Size: \(selectedSize) pt")
                    .font(.headline)
                    .padding()
                Text("Selected Color: \(selectedColorName)")
                    .font(.headline)
                    .padding()
            }
            .navigationTitle("Font Picker")
        }
    }

    // MARK: - Delegate Methods
    func didPickFont(fontName: String) {
        selectedFont = fontName
    }

    func didPickColor(_ color: Color, colorName: String) {
        selectedColor = color
        selectedColorName = colorName
    }

    func didPickSize(sizeName: String) {
        selectedSize = sizeName
    }
}

// MARK: - Font Picker View
struct FontPickerView: View {
    var delegate: FontPickerDelegate?
    @Environment(\.dismiss) var dismiss

    private let fonts: [String] = [
        "Helvetica", "Courier", "Times New Roman", "Verdana", "Georgia",
        "Arial", "Chalkboard SE", "Futura", "Avenir", "Gill Sans"
    ]

    var body: some View {
        NavigationStack {
            List(fonts, id: \.self) { font in
                Button(action: {
                    delegate?.didPickFont(fontName: font)
                    dismiss()
                }) {
                    Text(font)
                        .font(.custom(font, size: 18))
                        .padding()
                }
            }
            .navigationTitle("Pick a Font")
        }
    }
}

// MARK: - Color Picker View
struct ColorPickerView: View {
    var delegate: ColorPickerDelegate?
    @Environment(\.dismiss) var dismiss
    
    private let colors: [(Color, String)] = [
        (.red, "Red"),
        (.blue, "Blue"),
        (.yellow, "Yellow"),
        (.black, "Black")
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Pick a Color")
                    .font(.headline)
                    .padding(5)
                    .foregroundColor(.red)

                ForEach(colors, id: \.0) { color, name in
                    Button(action: {
                        delegate?.didPickColor(color, colorName: name)
                        dismiss()
                    }) {
                        Circle()
                            .fill(color)
                            .frame(width: 30, height: 30)
                            .padding(5)
                    }
                }
                .padding()
            }
        }
    }
}

// MARK: - Size Picker View
struct SizePickerView: View {
    var delegate: SizePickerDelegate?
    @Environment(\.dismiss) var dismiss

    private let sizes: [String] = ["12", "14", "16", "18", "20", "24", "30", "36", "48", "60"]

    var body: some View {
        NavigationStack {
            List(sizes, id: \.self) { size in
                Button(action: {
                    delegate?.didPickSize(sizeName: size)
                    dismiss()
                }) {
                    Text(size)
                        .font(.system(size: CGFloat(Int(size) ?? 16)))
                        .padding()
                }
            }
            .navigationTitle("Pick a Size")
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
