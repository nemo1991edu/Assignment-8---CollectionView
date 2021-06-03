import UIKit

let filterItems = ["Mexican", "American", "Mediterranean", "Greek", "Indian"]
let restaurants = [
    Restaurant(name: "Chancho Tortilleria", filter: "Mexican", price: "$"),
    Restaurant(name: "Antojitos Cantina", filter: "Mexican", price: "$$"),
    Restaurant(name: "Falafel King", filter: "Mediterranean", price: "$"),
    Restaurant(name: "Aladdin Café", filter: "Mediterranean", price: "$$"),
    Restaurant(name: "Takis' Taverna", filter: "Greek", price: "$$$"),
    Restaurant(name: "Stepho's Souvlaki", filter: "Greek", price: "$$$"),
    Restaurant(name: "Dosa & Curry", filter: "Indian", price: "$$$"),
    Restaurant(name: "Salam Bombay", filter: "Indian", price: "$$"),
    Restaurant(name: "Mo Burger", filter: "American", price: "$"),
    Restaurant(name: "Bistro Verde", filter: "American", price: "$$$"),
]
var selectedFilterItems = [false, false, false, false, false]
var displayedRestaurants = restaurants
var selectedFilters = filterItems

class FoodViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var filterCollectionView: FilterCollectionView!
    @IBOutlet weak var restaurantCollectionView: RestaurantCollectionView!
    
//    var delegate: FilterTappedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        
        restaurantCollectionView.delegate = self
        restaurantCollectionView.dataSource = self
        
        setupFilterLayout()
        setupRestaurantLayout()
    }
    
    func onFilterTapped(filter: String) {
        print(filter)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.filterCollectionView {
            return filterItems.count
        } else {
            return displayedRestaurants.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.filterCollectionView {
            selectedFilterItems[indexPath.item].toggle()
            filterCollectionView.reloadData()
            selectedFilters = filterItems.indices.filter({ selectedFilterItems[$0] }).map({ filterItems[$0] })
            
            displayedRestaurants = []
            for restaurant in restaurants {
                for selectedFilter in selectedFilters {
                    if restaurant.filter == selectedFilter {
                        displayedRestaurants.append(restaurant)
                    }
                }
            }
            if displayedRestaurants.count == 0 {
                displayedRestaurants = restaurants
            }
            restaurantCollectionView.reloadData()
        } else {
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.filterCollectionView {
            let filterCell = filterCollectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterCollectionViewCell
            filterCell.filterLabel.text = filterItems[indexPath.item]
            filterCell.contentView.layer.cornerRadius = 10
            if selectedFilterItems[indexPath.item] {
                filterCell.filterLabel.backgroundColor = .systemBlue
                filterCell.filterLabel.textColor = .white
            } else {
                filterCell.filterLabel.backgroundColor = .white
                filterCell.filterLabel.textColor = .systemBlue
            }
            
            return filterCell
        } else {
            let restaurantCell = restaurantCollectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCollectionViewCell
            restaurantCell.nameLabel.text = displayedRestaurants[indexPath.item].name
            restaurantCell.filterLabel.text = displayedRestaurants[indexPath.item].filter
            restaurantCell.priceLabel.text = displayedRestaurants[indexPath.item].price
            restaurantCell.imageView.image = UIImage.init(named: displayedRestaurants[indexPath.item].name)
            restaurantCell.imageView.contentMode = .scaleAspectFill
            return restaurantCell
        }
    }
    
    fileprivate func setupFilterLayout() {
        let spacing: CGFloat = 5
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3 * CGFloat(filterItems.count)), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: filterItems.count)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        filterCollectionView.setCollectionViewLayout(layout, animated: false)
    }
    

    fileprivate func setupRestaurantLayout() {
        let spacing: CGFloat = 5
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.28))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        let layout = UICollectionViewCompositionalLayout(section: section)
        restaurantCollectionView.setCollectionViewLayout(layout, animated: false)
    }
}
