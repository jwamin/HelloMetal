import UIKit

class ViewController:UIViewController{
    
    var renderer:MetalRenderer?
    var link:CADisplayLink!
    
    
    var metalView:MTKView!{
        get{
            return self.view as! MTKView
        }
    }
    
    override func loadView() {
        self.view = MTKView(frame: (UIApplication.shared.delegate?.window!?.frame)!)
    }
    
    override func viewDidLoad() {
        
        guard let device = MTLCreateSystemDefaultDevice() else {
            print("no metal")
            return
        }
        
        //setup label
        
        let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 300, height: 100)))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = device.name
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica Neue", size: 50.0)
        metalView.addSubview(label)
        
        
        NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: metalView, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
        
        NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: metalView, attribute: .width, multiplier: 1.0, constant: 0)
            .isActive = true
        NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: metalView, attribute: .bottomMargin, multiplier: 1.0, constant: -30).isActive = true
        renderer = MetalRenderer(metalView: metalView, device: device)
        //renderer?.mtkView(metalView, drawableSizeWillChange: metalView.drawableSize)
        
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        renderer?.mtkView(metalView, drawableSizeWillChange: metalView.drawableSize)
    }
    
    var touchInProgress = false {
        didSet{
            renderer?.setTouchInProgress(touchInProgress)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchInProgress = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchInProgress = false
    }
    
}
