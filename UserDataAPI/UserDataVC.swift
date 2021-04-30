import UIKit

class UserDataVC: UIViewController
{
    @IBOutlet weak var userTabV: UITableView!
    var userArr = [NSDictionary]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.userDataApi()
    }
    
    func userDataApi()
    {
        URLSession.shared.dataTask(with: URL(string: "https://gorest.co.in/public-api/users")!) { (data, resp, err) in
            print("Response Here \n \n Data - \(String(describing: data)) \n Response - \(String(describing: resp)) \n Error - \(String(describing: err))")
            if let error = err
            {
                print("Error: \(error.localizedDescription)")
                return
            }
            if let dataResp = data
            {
                do{
                    let jsonResp = try JSONSerialization.jsonObject(with: dataResp, options: .mutableContainers) as! NSDictionary
                    print("\(jsonResp)")
                    let response = jsonResp.value(forKey: "data") as! [NSDictionary]
                    self.userArr = response
                    print("Response: \(self.userArr)")
                    DispatchQueue.main.async {
                        self.userTabV.reloadData()
                    }
                }catch{
                    print("Exception Here")
                }
            }
        }.resume()
    }
}

extension UserDataVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return userArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dict = userArr
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserDataTVC") as! UserDataTVC
        let Id = dict[indexPath.row].value(forKey: "id") as! Int
        let Name = dict[indexPath.row].value(forKey: "name") as! String
        let Email = dict[indexPath.row].value(forKey: "email") as! String
        let Gender = dict[indexPath.row].value(forKey: "gender") as! String
        let Status = dict[indexPath.row].value(forKey: "status") as! String
        cell.idLbl.text = String(Id)
        cell.nameLbl.text = Name
        cell.emailLbl.text = Email
        cell.genderLbl.text = Gender
        cell.statusLbl.text = Status
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 170
    }
}

class UserDataTVC: UITableViewCell
{
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
}
