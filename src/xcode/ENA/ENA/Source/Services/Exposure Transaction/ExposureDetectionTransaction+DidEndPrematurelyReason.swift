// Corona-Warn-App
//
// SAP SE and all other contributors
// copyright owners license this file to you under the Apache
// License, Version 2.0 (the "License"); you may not use this
// file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import Foundation

extension ExposureDetectionTransaction {
	enum DidEndPrematurelyReason {
		/// Delegate was unable to provide an exposure manager to the transaction.
		case noExposureManager
		/// The actual exposure summary detection was started but did either produce an error
		/// or no summary.
		case noSummary(Error?)
		/// It was not possible to determine the remote days and/or hours that can be loaded.
		case noDaysAndHours
		/// Unable to get exposure configuration
		case noExposureConfiguration
		/// Unable to write diagnosis keys
		case unableToDiagnosisKeys
	}
}
