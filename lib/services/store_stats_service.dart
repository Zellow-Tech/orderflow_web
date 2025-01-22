class StatsService {
  StatsService({this.checkouts, this.storeListings});

  List? checkouts = [];
  List? storeListings = [];

// sales stats methods

  // the total lifetime sales
  double totalLifetimeSales(List checkouts) {
    double val = 0.0;

    for (var item in checkouts) {
      val += item['extraCharges'][1] +
          item['extraCharges'][0] +
          item['storeBillTotal'] +
          item['quickAddsTotal'];
    }
    return val;
  }

  // the total unique users
  List totalUniqueUsers(List checkouts) {
    List users = [];

    for (var checkout in checkouts) {
      users.add(checkout['payee']['name']);
    }
    return users.toSet().toList();
  }

  // the total stock value before and after sales
  List totalStockValueBASales(List checkouts, List storeListings) {
    double storeListingsTotalATM = 0.0;
    double lifetimesales = 0.0;

    // standard check for all the other methods in this class

    // the primary function of this method
    // get the lifetime sales
    lifetimesales = totalLifetimeSales(checkouts);

    // get the current store listings total
    for (var item in storeListings) {
      storeListingsTotalATM += item['price'] * item['qty'];
    }

    // the result is in the form sales value [ before sales aka lifetime value, after sales aka value current]
    return [storeListingsTotalATM + lifetimesales, storeListingsTotalATM];
  }

  // the total invoice value v total bill value
  List totalBillInvValues(List checkouts) {
    double billVal = 0.0;
    double invVal = 0.0;
    // the primary function of this method
    // get the current bill and invoice values separately
    for (int i = 0; i < checkouts.length; i++) {
      checkouts[i]['isInvoice']
          ? invVal += checkouts[i]['storeBillTotal'] +
              checkouts[i]['quickAddsTotal'] +
              checkouts[i]['extraCharges'][0] +
              checkouts[i]['extraCharges'][1]
          : billVal += checkouts[i]['storeBillTotal'] +
              checkouts[i]['quickAddsTotal'] +
              checkouts[i]['extraCharges'][0] +
              checkouts[i]['extraCharges'][1];
    }

    // the result is in the form sales value [ total bill value, total invoice sales]
    return [billVal, invVal];
  }

// store stats methods

  // the most used payment methods
  paymentMethodsStats(List checkouts) {
    List<int> paymentModeCount = [0, 0, 0, 0, 0, 0, 0];

    // the primary function of this method
    // assess the most number of checkout data
    for (var item in checkouts) {
      // now go over the payment mode
      for (int i = 0; i < 7; i++) {
        // add to index
        item['paymentMode'][i] ? paymentModeCount[i] += 1 : null;
      }
    }

    // the result is in the form sales value [ total bill value, total invoice sales]
    return paymentModeCount;
  }

  // the item sale and leaderboard
  List topMoversFromStore(List checkouts) {
    // res format = [ { 'name':,'qtySold':,'totalSalesValue': } ]
    List res = [];
    // the checkouts list
    for (var item in checkouts) {
      // loop through the store items added
      for (var storeAddsItem in item['storeAddsItems']) {
        // add it to list if not exists else update the list
        if (res.any((map) => map.containsValue(storeAddsItem['name']))) {
          // update the value with a loop over res
          for (var val in res) {
            // check to match name
            if (val['name'] == storeAddsItem['name']) {
              val['qtySold'] += storeAddsItem['qty'];
              val['totalSalesValue'] +=
                  storeAddsItem['qty'] * storeAddsItem['price'];
            }
          }
        }
        // add a new one
        else {
          res.add({
            'name': storeAddsItem['name'],
            'qtySold': storeAddsItem['qty'],
            'totalSalesValue': storeAddsItem['qty'] * storeAddsItem['price']
          });
        }
      }
    }

    return res;
  }

  // the store items sales vs quick adds sales
  List storeItemsSalesVQuickAddsSales() {
    return [];
  }
}
