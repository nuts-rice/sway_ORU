#![allow(unused)]
fn main() {
    use fuel_tx::Salt;
    use fuels_abigen_macro::abigen;
    use fuels_contract::contract::Contract;
    use rand::rngs::StdRng;
    use rand::{Rng, SeedableRng};

    abigen!{MishkaORU, "./simple-storage-abi.json"};

    #[tokio::test]

    async fn harness() {
        let rng = &mut StdRng::seed_from_u64(23222u64);

        let salt: [u8; 32] = rng.gen();
        let salt = Salt::from(salt);
        let compiled = Contract::compile_sway_contract("./", salt).unwrap();

        let (client, _contract_id) = Contract::launch_and_deploy(&compiled).await.unwrap();

        let contract_instance = MishkaORU::new(compiled, client);

        let result = contract_instance
            .initialize_counter(69)
            .call()
            .await
            .unwrap();

        assert_eq!(69, result.value);

        let result = contract_instance
            .increment_counter(10)
            .call()
            .await
            .unwrap();

        assert_eq!(79, result.value)
    }
}
