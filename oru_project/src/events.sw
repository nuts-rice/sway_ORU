contract;
use crate::prelude::*;
use alloc::collections::btree_map::BTreeMap as HashMap;
use core::convert::{TryFrom, TryInto};
use core::fmt;
use core::str::FromStr;
use flex_error::{define_error, TraceError};
use prost::alloc::fmt::Formatter;
use serde_derive::{Deserialize, Serialize};
use tendermint::abci::Event as AbciEvent;












define_error! {
    Error {
          Height
            [HeightError]
            | _ | {"Error parsing height"},

            Parse
                [ValidatorError]
                | _ | {"Parse error"},

            Client
                [client_error::Error]
                | _ | {"Client error"}m,

            Channel
                [ channel_error::Error ]
                | _ | { "channel error" },

            Timestamp
                [ ParseTimestampError ]
                | _ | { "error parsing timestamp" },

            MissingKey
                { key: String }
                | e | { format_args!("missing event key {}", e.key) },

            Decode
                [ TraceError<prost::DecodeError> ]
                | _ | { "error decoding protobuf" },

            SubtleEncoding
                [ TraceError<subtle_encoding::Error> ]
                | _ | { "error decoding hex" },

            MissingActionString
                | _ | { "missing action string" },

            IncorrectEventType
                { event: String }
                | e | { format_args!("incorrect event type: {}", e.event) },
    }
O}
