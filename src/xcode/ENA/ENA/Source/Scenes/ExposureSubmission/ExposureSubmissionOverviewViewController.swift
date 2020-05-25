//
//  ExposureSubmissionIntroViewController.swift
//  ENA
//
//  Created by Marc-Peter Eisinger on 19.05.20.
//  Copyright © 2020 SAP SE. All rights reserved.
//

import Foundation
import UIKit


struct ExposureSubmissionTestResult {
	let isPositive: Bool
	let receivedDate: Date
	let transmittedDate: Date?
}


class ExposureSubmissionOverviewViewController: DynamicTableViewController {
	private var testResults: [ExposureSubmissionTestResult] = [ExposureSubmissionTestResult(isPositive: true, receivedDate: Date(), transmittedDate: Date())]
	private var mostRecentTestResult: ExposureSubmissionTestResult? { testResults.last }
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		dynamicTableViewModel = dynamicTableData()
		
		tableView.register(UINib(nibName: String(describing: ExposureSubmissionTestResultHeaderView.self), bundle: nil), forHeaderFooterViewReuseIdentifier: "test")
	}
	
	
	@IBAction func unwindToExposureSubmissionIntro(_ segue: UIStoryboardSegue) { }
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		switch Segue(segue) {
		case .tanInput:
			(segue.destination as? ExposureSubmissionTanInputViewController)?.initialTan = sender as? String
		case .qrScanner:
			(segue.destination as? ExposureSubmissionQRScannerNavigationController)?.scannerViewController?.delegate = self
		default:
			break
		}
	}
}


extension ExposureSubmissionOverviewViewController {
	enum Segue: String, SegueIdentifiers {
		case tanInput = "tanInputSegue"
		case qrScanner = "qrScannerSegue"
		case testDetails = "testDetailsSegue"
		case previousTestResults = "previousTestResultsSegue"
	}
}


extension ExposureSubmissionOverviewViewController {
	enum HeaderReuseIdentifier: String, TableViewHeaderFooterReuseIdentifiers {
		case test = "test"
	}
}


extension ExposureSubmissionOverviewViewController: ExposureSubmissionQRScannerDelegate {
	func qrScanner(_ viewController: ExposureSubmissionQRScannerViewController, didScan code: String) {
		viewController.delegate = nil
		viewController.dismiss(animated: true) {
			self.performSegue(withIdentifier: Segue.tanInput, sender: code)
		}
	}
}


private extension ExposureSubmissionOverviewViewController {
	func dynamicTableData() -> DynamicTableViewModel {
		var data = DynamicTableViewModel([])
		
		let header: DynamicTableViewModel.Header
		
		if let testResult = mostRecentTestResult {
			header = .identifier(HeaderReuseIdentifier.test, action: .perform(segue: Segue.testDetails), configure: { view, indexPath in
				guard let view = view as? ExposureSubmissionTestResultHeaderView else { return }
				view.configure(
					title: "Ergebnis: " + (testResult.isPositive ? "positiv" : "negativ"),
					subtitle: "SARS-CoV-2 wurde nachgewiesen",
					received: "Eingangsdatum: 2. Mai 2020",
					status: "Befund wurde am 4. Mai 2020 übermittelt"
				)
			})
		} else {
			header = .image(UIImage(named: "app-information-people"))
		}
		
		data.add(
			.section(
				header: header,
				separators: false,
				cells: [
					.semibold(text: "Wenn Sie einen Covid-19 Test gemacht haben, können Sie sich hier das Testergebnis anzeigen lassen."),
					.regular(text: "Sollte das Testergebnis positiv sein, haben Sie zusätzlich die Möglichkeit Ihren Befund anonym zu melden, damit Kontaktpersonen informiert werden können.")
				]
			)
		)
		
		data.add(
			.section(
				header: .text("Nächste Schritte"),
				cells: [
					.icon(action: .perform(segue: Segue.tanInput), text: "Identifikationsnummer eingeben", image: UIImage(systemName: "doc.text"), backgroundColor: .preferredColor(for: .brandBlue), tintColor: .black),
					.icon(action: .perform(segue: Segue.qrScanner), text: "QR-Code scannen", image: UIImage(systemName: "doc.text"), backgroundColor: .preferredColor(for: .brandBlue), tintColor: .black)
				]
			)
		)
		
		if !testResults.isEmpty {
			data.add(
				.section(
					header: .blank,
					cells: [
						.icon(action: .perform(segue: Segue.previousTestResults), text: "Vorherige Testergebnisse", image: UIImage(systemName: "clock"), backgroundColor: .preferredColor(for: .brandBlue), tintColor: .black)
					]
				)
			)
		}
		
		data.add(
			.section(
				header: .text("Hilfe"),
				cells: [
					.phone(text: "Hotline anrufen", number: "0123456789")
				]
			)
		)
		
		return data
	}
}


private extension DynamicTableViewModel.Cell {
	static func phone(text: String, number: String) -> DynamicTableViewModel.Cell {
		.icon(action: .call(number: number), text: text, image: UIImage(systemName: "phone.fill"), backgroundColor: .preferredColor(for: .brandMagenta), tintColor: .white)
	}
}