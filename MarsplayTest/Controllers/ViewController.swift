//
//  ViewController.swift
//  MarsplayTest
//
//  Created by Akshay on 19/01/20.
//  Copyright © 2020 Akshay Deep Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pageIndex: Int = 1
    var lastSearchedKey: String = ""
    var task: URLSessionDataTask?
    var isPaginationInProgress: Bool = false
    
    let datasource: ViewControllerDataSource = ViewControllerDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setResources()
    }
    
    func setResources() {
        collectionView.register(UINib(nibName: "DisplayCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DisplayCollectionViewCell")
        collectionView.dataSource = datasource
        collectionView.delegate = self
        searchBar.delegate = self
    }
    
    func getData(searchKey: String, isPagination: Bool) {
        if lastSearchedKey == searchKey && !isPagination {
            return
        }
        if isPagination {
            self.pageIndex += 1
            isPaginationInProgress = true
        } else {
            pageIndex = 1
        }
        lastSearchedKey = searchKey
        
        task?.cancel()
        
        task = OmdbClient.searchDataOnOMDB(searchString: lastSearchedKey, page: pageIndex, completion: {[weak self] (photos, error) in
            self?.isPaginationInProgress = false
            guard let parsedPhotos = photos else {
                self?.datasource.updatenewImages(images: [])
                self?.collectionView.reloadData()
                return
            }
            if isPagination {
                self?.datasource.addNewImages(newImage: parsedPhotos)
            } else {
                self?.datasource.updatenewImages(images: parsedPhotos)
            }
            self?.collectionView.reloadData()
        })
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width / 2, height: 280)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let detailController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailController.dataModel = self.datasource.photos[indexPath.item]
            self.navigationController?.pushViewController(detailController, animated: true)
        }
        
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let paginationHeight: CGFloat = 100
        
        guard (contentHeight - scrollView.contentOffset.y - UIScreen.main.bounds.height) < paginationHeight, !isPaginationInProgress else {
            return
        }
        isPaginationInProgress = true
        getData(searchKey: lastSearchedKey, isPagination: true)
        
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getData(searchKey: searchText, isPagination: false)
    }
}

